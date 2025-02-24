(test "symbols: it should create interned symbols"
      (lambda (t)
        (t.is (eq? 'foo 'foo) #t)
        (t.is (eqv? 'foo 'foo) #t)
        (t.is (equal? 'foo 'foo) #t)
        (t.is (symbol=? 'foo 'foo) #t)))

(test "symbols: it should uninterned symbols"
      (lambda (t)
        (let ((a (string->uninterned-symbol "foo"))
              (b (string->uninterned-symbol "foo")))
          (t.is (eq? a b) #f)
          (t.is (eqv? a b) #f)
          (t.is (equal? a b) #f)
          (t.is (symbol=? a b) #f)
          (t.is (string=? a.__name__ b.__name__) #t))))

(test "symbols: it should create gensyms"
      (lambda (t)
        (let ((a (gensym "foo"))
              (b (gensym "bar")))
          (t.is (eq? a b) #f)
          (t.is (eqv? a b) #f)
          (t.is (equal? a b) #f)
          (t.is (symbol=? a b) #f)
          (t.is (equal? a.__name__ b.__name__) #f))))

(test "symbols: it should generate unique symbol"
      (lambda (t)
        (let ((a (generate-uninterned-symbol))
              (b (generate-uninterned-symbol))
              (c (generate-uninterned-symbol "foo"))
              (d (generate-uninterned-symbol "foo")))
          (for-each (lambda (symbol)
                      (t.is (symbol-interned? symbol) #f))
                    (list a b c d))
          (for-each (lambda (pair)
                      (let ((a (car pair))
                            (b (cdr pair)))
                        (t.is (eq? a b) #f)
                        (t.is (eqv? a b) #f)
                        (t.is (equal? a b) #f)
                        (t.is (symbol=? a b) #f)
                        (t.is (equal? a.__name__ b.__name__) #f)))))))

(test "symbols: gensyms should be uninterned"
      (lambda (t)
        (t.is (symbol-interned? #:foo) #f)
        (t.is (symbol-interned? (gensym)) #f)
        (t.is (symbol-interned? (gensym "foo")) #f)))

(test "symbols: it should create symbols with colon in the middle"
      (lambda (t)
        (let ((detect:signature "foo"))
          (t.is (symbol->string 'detect:signature) "detect:signature")
          (t.is detect:signature "foo"))))
