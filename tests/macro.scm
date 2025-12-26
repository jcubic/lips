(test "macro: should define macro"
      (lambda (t)
        (define-macro (foo x)
          `(list ',x))
        (t.is (foo bar) '(bar))))

(test "macro: should create documentation"
      (lambda (t)
        (define-macro (foo x)
          "(foo x)"
          `(list ',x))
        (t.is (foo bar) '(bar))
        (t.is foo.__doc__ "(foo x)")))

(test "macro: should create macro with lambda"
      (lambda (t)
        (define-macro foo (lambda (x)
                            `(list ',x)))
        (t.is (foo bar) '(bar))))

(test "macro: should create lambda macro with documentation"
      (lambda (t)
        (define-macro foo (lambda (x)
                            "(foo x)"
                            `(list ',x)))
        (t.is foo.__doc__ "(foo x)")
        (t.is (foo bar) '(bar))))
