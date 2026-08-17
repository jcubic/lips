;; -----------------------------------------------------------------------------
;; Smoke test: a fast end-to-end sanity check of a freshly built interpreter.
;;
;; It verifies that the standard library bootstraps and that core evaluation
;; works. It is run BOTH in the default lexical scope and in dynamic scope
;; (`-d`), so it also guards against the interpreter failing to boot or hanging
;; in dynamic mode (see `make smoke`). For that reason it deliberately avoids
;; higher-order library functions that take callbacks (map/filter/for-each/...),
;; which have different behaviour under dynamic scope - broad coverage of those
;; lives in the full test suite (`make test`).
;;
;; On the first failed check it prints a FAIL line and exits non-zero via error.
;; -----------------------------------------------------------------------------

(define failures 0)

(define (check name actual expected)
  (if (equal? actual expected)
      (begin (display "ok   ") (display name) (newline))
      (begin
        (set! failures (+ failures 1))
        (display "FAIL ") (display name)
        (display " => ") (write actual)
        (display " (expected ") (write expected) (display ")") (newline))))

;; arithmetic: native, bignum and comparison
(check "add" (+ 1 2 3) 6)
(check "bignum" (* 1000000000000 1000000000000) 1000000000000000000000000)
(check "compare" (< 1 2 3) #t)
(check "rational" (+ 1/3 1/6) 1/2)

;; tail recursion driven by a named let (exercises the TCO evaluator)
(check "sum-loop"
       (let loop ((i 0) (acc 0)) (if (> i 1000) acc (loop (+ i 1) (+ acc i))))
       500500)

;; ordinary recursion
(check "fib"
       (letrec ((fib (lambda (n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))))
         (fib 12))
       144)

;; closures / mutable captured state
(check "closure"
       (let ((c (let ((n 0)) (lambda () (set! n (+ n 1)) n))))
         (c) (c) (c))
       3)

;; list primitives
(check "list" (car (cdr (list 1 2 3))) 2)
(check "reverse" (reverse (list 1 2 3)) (list 3 2 1))
(check "length" (length (list 1 2 3 4)) 4)
(check "append" (append (list 1 2) (list 3 4)) (list 1 2 3 4))
(check "assoc" (cdr (assoc 'b (list (cons 'a 1) (cons 'b 2)))) 2)

;; strings and symbols
(check "string" (string-append "a" "b" "c") "abc")
(check "symbol" (symbol->string 'hello) "hello")
(check "number->string" (number->string 255 16) "ff")

;; quasiquote
(check "quasiquote" `(1 ,(+ 1 1) ,@(list 3 4)) (list 1 2 3 4))

(if (> failures 0)
    (error "smoke test failed" failures)
    (begin (display "smoke: all checks passed") (newline)))
