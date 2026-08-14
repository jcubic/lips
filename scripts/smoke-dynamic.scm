;; -----------------------------------------------------------------------------
;; Minimal smoke test for DYNAMIC scope (run with `-d`, see `make smoke`).
;;
;; Its primary job is to guard the fact that the interpreter must BOOTSTRAP and
;; evaluate under dynamic scope without hanging (bootstrapping the stdlib in
;; dynamic scope used to loop forever) and that dynamic scoping actually takes
;; effect. Dynamic scope currently breaks some higher-order / structural stdlib
;; functions (e.g. `equal?`, `map`), so this file intentionally sticks to the
;; subset that works under dynamic scope and asserts with `=` rather than
;; `equal?`.
;; -----------------------------------------------------------------------------

(define (assert name ok)
  (if ok
      (begin (display "ok   ") (display name) (newline))
      (error (string-append "dynamic smoke failed: " name))))

(assert "add" (= (+ 1 2 3) 6))
(assert "compare" (< 1 2 3))
(assert "tail-loop"
        (= 500500 (let loop ((i 0) (acc 0))
                    (if (> i 1000) acc (loop (+ i 1) (+ acc i))))))
(assert "fib"
        (= 144 (letrec ((fib (lambda (n)
                               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))))
                 (fib 12))))

;; dynamic scope must actually be in effect: `f` resolves the free variable `x`
;; through the caller's binding, not the one visible where `f` was defined.
(define x 1)
(define (f) x)
(assert "dynamic-scope" (= 99 (let ((x 99)) (f))))
(assert "lexical-fallback-off" (= 1 (f)))

(display "dynamic smoke: all checks passed") (newline)
