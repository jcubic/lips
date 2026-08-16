#!/usr/bin/env -S lips -q
;; -----------------------------------------------------------------------------
;; Interpreter speed benchmark (Benchmark.js).
;;
;; Output is a set of plain Benchmark.js lines on stdout consumed by
;; github-action-benchmark (tool: benchmarkjs) to track evaluator performance
;; over time and across branches. Unlike test wall-time (which depends on the
;; number of tests) these numbers are a stable metric of the evaluator itself.
;;
;; All workloads use shallow recursion / native JS iteration so they run on both
;; the old recursive evaluator and the continuation (tco) evaluator, and each is
;; small enough that the whole suite finishes in a couple of minutes.
;; -----------------------------------------------------------------------------

;; performance instrumentation (see lib/bootstrap.scm): the workloads below are
;; all acyclic and synchronous, so we turn off cycle detection and promise
;; resolution for the whole suite. These are global read-time switches; keep
;; them here so the benchmark reflects the fast path.
#!no-cycle
#!no-promise

(load "./helpers/helpers.scm")

;; a big JS array whose elements are mapped with a LIPS callback - this hits the
;; hot path (a scheme lambda invoked from JS for every element) and was measured
;; to be slow, so it is the centrepiece of the suite.
(define (make-array n)
  (Array.from &(:length n) (lambda (_ i) i)))

(suite
 ;; big array + JS .map with an arithmetic (bignum) callback
 (add "array-map: pow"
      (lambda ()
        (--> (make-array 10000)
             (map (lambda (x)
                    (let ((y (* x x)))
                      (** y 2)))))))

 ;; big array + JS .map with a more expensive callback (inner loop of modular
 ;; arithmetic per element)
 (add "array-map: mix"
      (lambda ()
        (--> (make-array 10000)
             (map (lambda (x)
                    (let loop ((i 8) (a 1))
                      (if (= i 0)
                          a
                          (loop (- i 1) (modulo (+ (* a x) 7) 1000003)))))))))

 (add "recursion: nested loops"
      (lambda ()
        (define (sum n)
          (let ((sum 0) (list (range n)))
            (while (not (null? list))
              (set! sum (+ sum (car list)))
              (set! list (cdr list)))
            sum))

        (define (loop x)
          (let ((i 100))
            (while (> i 0)
              (let loop ((i x))
                (if (> i 0)
                    (loop (- i 1))))
              (set! i (- i 1))
              (sum 100))))

        (loop 100)))

 ;; big array + JS .map/.filter chain producing strings
 (add "array-map: string"
      (lambda ()
        (string-length
         (--> (make-array 5000)
              (map (lambda (x) (number->string (* x x))))
              (filter (lambda (s) (> (string-length s) 2)))
              (join "-")))))

 ;; classic recursion (function calls + arithmetic + conditionals), shallow and
 ;; small so Benchmark.js can collect many samples in a few seconds
 (add "recursion: fib(18)"
      (lambda ()
        (letrec ((fib (lambda (n)
                        (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))))
          (fib 18))))

 ;; many small recursions driven by native array iteration (a shallow, well
 ;; sampled variant of the recursion workload)
 (add "recursion: fib-map"
      (lambda ()
        (letrec ((fib (lambda (n)
                        (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))))
          (--> (make-array 200) (map (lambda (_) (fib 12))))))))
