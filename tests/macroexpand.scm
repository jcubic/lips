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

(test "expand of nested _ #357"
      (lambda (t)

        (define-syntax symbol
          (syntax-rules ()
            ((_ name)
             (let-syntax ((name (syntax-rules ()
                                  ((_)
                                   (list 'name)))))
               (name)))))

        (t.snapshot (macroexpand '(symbol hello)))))

;; a syntax-rules macro renames the identifiers it introduces to gensyms and
;; binds them in a fresh scope, so re-expanding its output has to continue in
;; THAT scope - otherwise the walk stops at the first level and a classic macro
;; reached through syntax-rules is left unexpanded
(test "expands through a chain of syntax-rules and classic macros"
      (lambda (t)
        (t.plan 3)
        (define-macro (twice x) `(begin ,x ,x))
        (define-syntax outer (syntax-rules () ((_ e) (twice e))))
        (define-syntax mid (syntax-rules () ((_ e) (outer e))))
        (t.is (macroexpand '(outer 1)) '(begin 1 1))
        (t.is (macroexpand '(mid 2)) '(begin 2 2))
        ;; macroexpand-1 still stops after a single step (it returns the raw
        ;; one-step output, so the introduced identifier is still a gensym)
        (t.is (equal? (macroexpand-1 '(mid 3)) (macroexpand '(mid 3))) #f)))
