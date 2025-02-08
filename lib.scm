(define tests 0)
(define passed 0)

(define-macro (assert a b)
  (let ((a_expr (gensym "a"))
        (b_expr (gensym "b")))
    `(let ((,a_expr (repr ,a))
           (,b_expr (repr ,b)))
       (set! tests (+ tests 1))
       (if (== ((. ,a_expr "cmp") ,b_expr) 0)
           (set! passed (+ passed 1))
           (print (concat "FAIL: "
                          ,a_expr
                          " != "
                          ,b_expr))))))

(define-macro (quote-promise expr)
  "(quote-promise expr) or '>expr

  Macro used to escape automati awaiting of the expression. It will be wrapped
  with a JavaScript class that behaves like Promise but will not be automatically
  resolved by LIPS like normal promises are."
  `(let ((env))
      (set! env (current-environment))
      (env.set (Symbol.for "__promise__") #t)
      (let ((env))
        (set! env (current-environment))
        (env.set (Symbol.for "__promise__") #f)
        ,expr)))

#;(define-macro (ignore expr)
  `(begin
     '>(begin ,@expr)
     #void))
