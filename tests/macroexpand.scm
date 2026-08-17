(test "should not expand let bindings"
      (lambda (t)
        (t.snapshot (macroexpand '(let ((++ (lambda (a b) (* a b)))) (++ 1 2))))
        (t.snapshot (macroexpand '(let ((++ 10)) (+ ++ ++))))))

(test "should only expand macro in body of let"
      (lambda (t)
        (define-macro (foo x) `(1 2 3 ,x))
        (define-macro (bar x) `(x y z ,x))

        (t.snapshot (macroexpand '(let ((foo 10)) (bar foo))))))

(test "should not expand lambda parameters"
      (lambda (t)
        (define-macro (foo x) `(1 2 3 ,x))
        (define-macro (bar x) `(x y z ,x))

        (t.snapshot (macroexpand '(lambda (foo) (bar foo))))))

(test "should not expand shadowed procedure name in recursive call"
      (lambda (t)
        (define-macro (foo x) `(1 2 3 ,x))
        (define-macro (bar x) `(x y z ,x))

        (t.snapshot (macroexpand '(define (foo x) (if (zero? x) (bar 0) (foo (- x 1))))))))

(test "should expand macro inside letrec function"
      (lambda (t)
        (define-macro (foo x) `(1 2 3 ,x))
        (define-macro (bar x) `(x y z ,x))

        (t.snapshot (macroexpand '(letrec ((foo (lambda () (bar x)))) (foo 10))))))

(test "is a function that recursively expands quoted code"
      (lambda (t)
        (define-macro (foo x) `(1 2 3 ,x))
        (define-macro (bar x) `(x y z ,x))
        ;; macroexpand is a function (breaking change), so the argument must be
        ;; quoted; nested macros are expanded to a fixed point
        (t.is (macroexpand '(foo (bar 5)))
              '(1 2 3 (x y z 5)))))

(test "macroexpand-1: expands only the outermost macro one level"
      (lambda (t)
        (define-macro (foo x) `(1 2 3 ,x))
        (define-macro (bar x) `(x y z ,x))
        (t.is (macroexpand-1 '(foo (bar 5)))
              '(1 2 3 (bar 5)))
        ;; a non-macro form is returned unchanged
        (t.is (macroexpand-1 '(+ 1 2))
              '(+ 1 2))))
