(test "should parse simple string"
      (lambda (t)
        (t.plan 1)
        (t.is $"foo" "foo")))

(test "should parse empty string"
      (lambda (t)
        (t.plan 3)
        (t.is $"" "")
        (t.is (list $"" $"foo") '("" "foo"))
        ;; `$""` as the last expression of the input: the parser used to
        ;; tokenize past the extension and fail on the unterminated string
        (t.is (eval (read (open-input-string "$\"\""))) "")))

(test "should handle escape characters"
      (lambda (t)
        (t.plan 1)
        (t.is $"foo \" bar" "foo \" bar")))

(test "should parse single expression"
      (lambda (t)
        (t.plan 2)
        (t.is $"foo ${10} bar" "foo 10 bar")
        (t.is $"foo ${(list 10)} bar" "foo (10) bar")))

(test "should use lexical scope"
      (lambda (t)
        (t.plan 1)
        (let ((x 10))
          (t.is $"x = ${(* x x)}" "x = 100"))))

(test "should handle spaces around expression"
      (lambda (t)
        (t.plan 2)
        (let ((x 10))
          (t.is $"x = ${ 10 }" "x = 10")
          (t.is $"x = ${ (* x x) }" "x = 100"))))
