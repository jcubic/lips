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
