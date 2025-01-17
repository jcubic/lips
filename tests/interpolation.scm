(test "interpolation: shoud parse simple string"
      (lambda (t)
        (t.plan 1)
        (t.is #"foo" "foo")))

(test "interpolation: should handle escape characters"
      (lambda (t)
        (t.plan 1)
        (t.is #"foo \" bar" "foo \" bar")))

(test "interpolation: should parse single expression"
      (lambda (t)
        (t.plan 2)
        (t.is #"foo ${10} bar" "foo 10 bar")
        (t.is #"foo ${(list 10)} bar" "foo (10) bar")))

(test "interpolation: should use lexical scope"
      (lambda (t)
        (t.plan 1)
        (let ((x 10))
          (t.is #"x = ${(* x x)}" "x = 100"))))

(test "interpolation: should handle spaces around expression"
      (lambda (t)
        (t.plan 2)
        (let ((x 10))
          (t.is #"x = ${ 10 }" "x = 10")
          (t.is #"x = ${ (* x x) }" "x = 100"))))
