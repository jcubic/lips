(test "case-lambda"
      (lambda (t)

        ;; example from R7RS without do macro
        (define range
          (case-lambda
           ((e) (range 0 e))
           ((b e) (let iter ((result ()) (i (- e 1)))
                    (if (< i b)
                        result
                        (iter (cons i result) (- i 1)))))))

        (t.is (range 3) '(0 1 2))
        (t.is (range 3 5) '(3 4))))

(test "string-map"
      (lambda (t)
        ;; example from R7RS spec
        (define result (string-map
                        (lambda (c k)
                          ((if (eqv? k #\u) char-upcase char-downcase)
                           c))
                        "studlycaps xxx"
                        "ululululul"))

        (t.is result "StUdLyCaPs")))

(test "vector-map"
      (lambda (t)

        ;; examples from R7RS spec
        (t.is (vector-map cadr '#((a b) (d e) (g h)))
              '#(b e h))

        (t.is (vector-map + '#(1 2 3) '#(4 5 6 7))
              '#(5 7 9))))

(test "some"
      (lambda (t)
        (t.is (some + '()) #f)
        (t.is (some odd? (list 1 2 3)) #t)
        (t.is (some odd? (list 2 4 6)) #f)))

(test "fold"
      (lambda (t)
        (t.is (fold * 1 (cdr (range 10))) 362880)))

(test "pluck"
      (lambda (t)
        (let ((name (pluck '__name__)))
          (t.is (name 'foo) "foo"))
        (let ((name (pluck "__name__")))
          (t.is (name 'foo) "foo"))
        (let ((none (pluck)))
          (t.is (none 'foo) '()))
        (let ((xy (pluck 'x 'y)))
          (t.is (xy &(:x 10 :y 20 :z 30)) &(:x 10 :y 20)))))

(test "predicates"
      (lambda (t)
        (t.is (regex? #/foo/) #t)
        (t.is (boolean? '()) #f)
        (t.is (boolean? #null) #f)
        (t.is (boolean? #void) #f)
        (t.is (boolean? #t) #t)
        (t.is (boolean? #f) #t)))

(test "find"
      (lambda (t)
        (t.is (find odd? (list 1 2 3)) 1)
        (t.is (find 2 (list 1 2 3)) 2)
        (t.is (find 2+10i (list 1/2 2 2+10i)) 2+10i)
        (t.is (find #\c (list #\a #\b #\c)) #\c)
        (t.is (find 'x (list 10 20 'x)) 'x)
        (t.is (find #t (list #f #f #t)) #t)
        (t.is (find #/^[0-9]+$/ (list "foo" "bar" "10")) "10")
        (t.is (find "10" (list "foo" "bar" "10")) "10")
        (t.is (find odd? (list 0 2 4 3)) 3)
        (t.is (find odd? (list 0 2 4 6)) #f)))

(test "typecheck"
      (lambda (t)
        (t.is (to.throw (typecheck "test" 10 (list "string"))) true)
        (t.is (try (typecheck "test" 10 (list "string") 0) (catch (e) e.message))
              "Expecting a string got number in expression `test` (argument 0)")
        (t.is (try (typecheck "test" 10 (list "string" "character") 0) (catch (e) e.message))
              "Expecting string or character got number in expression `test` (argument 0)")))

(test "let-values and let*-values"
      (lambda (t)

        (let ((a 10) (b 20) (c 30))
          (let*-values (((a b c) (values 1 2 3)) ((x y z) (values a b c)))
            (t.is (+ a b c x y z) 12)))

        (let ((a 10) (b 20) (c 30))
          (let-values (((a b c) (values 1 2 3)) ((x y z) (values a b c)))
            (t.is (+ x y z) 60)
            (t.is (+ a b c) 6)))))

(test "let-values as list"
      (lambda (t)
        (t.is (let-values ((x (values 3 4 5)) ((a b) (values 1 2)))
                (cons a (cons b x)))
              '(1 2 3 4 5))
        (t.is (let-values (((x y z) (values 1 2 3)) (a (values 4 5)))
                (cons x (cons y (cons z a))))
              '(1 2 3 4 5))))

(test "let*-values mixed values"
      (lambda (t)
        (define (div-mul x y)
          (values (/ x y) (* x y)))

        (t.is (let*-values (((x) 2)
                            ((y) 10)
                            ((div mul) (div-mul x y)))
                (+ div mul))
              101/5)))

(test "let*-values empty bindings body is a new scope"
      (lambda (t)
        ;; a (define ...) in the body of an empty let*-values must be local to
        ;; it, not leak into the surrounding scope (regression: it used to
        ;; expand to (begin body ...) which splices the define)
        (t.is (let ((x 1))
                (let*-values () (define x 2) #f)
                x)
              1)
        ;; an empty let*-values still evaluates its body
        (t.is (let*-values () 42) 42)))

(test "should render SXML string"
      (lambda (t)
        (define preact (require "preact"))
        (define h preact.h)
        (define jsx->string (require "preact-render-to-string"))

        (define-class Button1 preact.Component
          (render (lambda (self props state)
                    (sxml (button (@ (id "btn1"))
                                  props.label)))))

        (define (Button2 props)
          (sxml (button (@ (id "btn2") (onClick (lambda () (alert "hello world")))) props.label)))

        (t.snapshot  (jsx->string (sxml (div (@ (data-foo "hello")
                                                (id "foo"))
                                             (Button1 (@ (label "me")))
                                             (Button2 (@ (label "me")))))))))

(test "fold/curry"
      (lambda (t)

        (define (fold-left proc knil list)
          (fold (lambda (acc elt) (proc elt acc)) knil list))

        (define (test fn)
          (t.is (procedure? fn) true)
          (t.is (fn 4) 10))

        (let ((fn (curry (curry (curry + 1) 2) 3)))
          (test fn))

        (let ((fn (fold-left curry + '(1 2 3))))
          (test fn))))

(test "reduce/curry"
      (lambda (t)

        (define (test fn)
          (t.is (procedure? fn) true)
          (t.is (fn 4) 10))

        (let ((fn (reduce curry + '(1 2 3))))
          (test fn))))

(test "char properties"
      (lambda (t)
        ;; function taken from book Sketchy Scheme by Nils M Holm
        (define (char-properties x)
          (apply append
                 (map (lambda (prop)
                        (cond (((car prop) x)
                               (cdr prop))
                              (else '())))
                      (list (cons char-alphabetic? '(alphabetic))
                            (cons char-numeric? '(numeric))
                            (cons char-upper-case? '(upper-case))
                            (cons char-lower-case? '(lower-case))
                            (cons char-whitespace? '(whitespace))))))

        (t.is (map char-properties '(#\C #\c #\1 #\#))
              '((alphabetic upper-case)
                (alphabetic lower-case)
                (numeric)
                ()))))

(test "context in class instance"
      (lambda (t)
        (let ((result (vector)))
          (define-class Foo Object
            (constructor (lambda (self)
                           (set! self.x 10)))
            (closure (lambda (self)
                       (--> result (push (eq? this self)))
                       (lambda ()
                         ;; function will not have this like in JavaScript
                         ;; but get it from closure (parent scope)
                         ;; like with arrow function in ES6
                         (--> result (push (eq? this self)))
                         (--> result (push this.x))
                         this))))
          (let* ((x (new Foo))
                 (closure (x.closure))
                 (v (closure)))
            (t.is v.x 10)
            (t.is result (vector true true 10))))))

;; bytevector tests from R7RS spec
(test "bytevector-u8-ref"
      (lambda (t)
        (define result (bytevector-u8-ref '#u8(1 1 2 3 5 8 13 21)
                                          5))
        (t.is result 8)))

(test "bytevector-u8-set!"
      (lambda (t)
        (define result (let ((bv (bytevector 1 2 3 4)))
                         (bytevector-u8-set! bv 1 3)
                         bv))
        (t.is result #u8(1 3 3 4))))

(test "bytevector-u8-copy"
      (lambda (t)
        (define a #u8(1 2 3 4 5))
        (t.is (bytevector-copy a 2 4) #u8(3 4))))

(test "bytevector-copy!"
      (lambda (t)
        (define a (bytevector 1 2 3 4 5))
        (define b (bytevector 10 20 30 40 50))
        (bytevector-copy! b 1 a 0 2)
        (t.is a #u8(1 2 3 4 5))
        (t.is b #u8(10 1 2 40 50))))

(test "utf8->string"
      (lambda (t)
        (t.is (utf8->string #u8(#xCE #xBB)) "λ")
        (let ((v #u8(#xCE #xBB #x41 #x41 #x41)))
           (t.is (utf8->string v 0 2) "λ")
           (t.is (utf8->string v 0 4) "λAA")
           (t.is (utf8->string v 2 4) "AA"))))

(test "string->utf8"
      (lambda (t)
        (t.is (string->utf8 "λ") #u8(#xCE #xBB))
        (let ((str "λAA"))
          (t.is (string->utf8 str 0 1) #u8(#xCE #xBB))
          (t.is (string->utf8 str 0 2) #u8(#xCE #xBB #x41))
          (t.is (string->utf8 str 1 3) #u8(#x41 #x41)))))

(test "atanh and log function"
      (lambda (t)
        ;; source: https://doc.scheme.org/surveys/ComplexLog/
        (define (atanh x)
          (/ (- (log (+ 1 x))
                (log (- 1 x)))
             2))
        (t.is (atanh -2)
              -0.5493061443340548+1.5707963267948966i)))

(test "Petrofsky let"
      (lambda (t)
        (t.is (let - ((n (- 1))) n) -1)))

(test "parameterize base"
      (lambda (t)
        (define radix
          (make-parameter
           10
           (lambda (x)
             (if (and (exact-integer? x) (<= 2 x 16))
                 x
                 (error (string-append "invalid radix " (repr x)))))))

        (define (f n) (number->string n (radix)))

        (t.is (f 12) "12")
        (t.is (parameterize ((radix 2))
                (f 12))
              "1100")))

(test "guard function with =>"
      (lambda (t)
        (t.is (guard (condition
                      ((assq 'a condition) => cdr)
                      ((assq 'b condition) => car))
                     (raise (list (cons 'b 23))))
              'b)))

(test "guard list"
      (lambda (t)
        (t.is (guard (condition
                      ((assq 'a condition) => cdr)
                      ((assq 'b condition) "error"))
                     (raise (list (cons 'b 23))))
              "error")))

(test "guard identity"
      (lambda (t)
        (t.is (guard (condition
                      ((assq 'a condition) => cdr)
                      ((assq 'b condition)))
                     (raise (list (cons 'b 23))))
              '(b . 23))))

(test "typeOf"
      (lambda (t)
        (define-record-type <pare>
          (kons x y)
          pare?
          (x kar set-kar!)
          (y kdr set-kdr!))

        (t.is (type (kons 1 2)) "record")))

(test "equal? on records"
      (lambda (t)
        (define-record-type <pare>
          (kons x y)
          pare?
          (x kar set-kar!)
          (y kdr set-kdr!))

        (t.is (kons 1 2) (kons 1 2))))

(test "equal? on same cycle"
      (lambda (t)
        (let ((x (cons 1 (cons 2 '()))))
          (set-cdr! (cdr x) x)
          (t.is (equal? x x) #t))))

(test "equal?  on identical cycles"
      (lambda (t)
        (let ((a (list 1 2))
              (b (list 1 2)))
          (set-cdr! (cdr a) a)
          (set-cdr! (cdr b) b)
          (t.is (equal? a b) #t))))

(test "define-values with dot"
      (lambda (t)
        (define-values (a . b)
          (values 1 2))
        (t.is (cons a b) '(1 2))))

(test "define-values with several vars and a dotted rest"
      (lambda (t)
        (define-values (x y . z)
          (values 1 2 3 4))
        (t.is (list x y z) '(1 2 (3 4)))))

(test "iterators"
      (lambda (t)
        (let ((obj (object))
              (max 5))
          (set-object! obj Symbol.iterator
                    (lambda ()
                      (let ((i 0))
                        (object :next (lambda ()
                                        (set! i (+ i 1))
                                        (if (> i max)
                                            `&(:done #t)
                                            `&(:done #f :value ,(/ 1 i))))))))
          (t.is (iterator->array obj) #(1 1/2 1/3 1/4 1/5))
          (t.is (Array.from (iterator->array obj)) #(1 0.5 0.3333333333333333 0.25 0.2)))))

(test "string interpolation"
      (lambda (t)
        (let ((x 10) (y 20))
          (t.snapshot $"this is string \" ${(+ x y)} hello ${(repr "hello" #t)}
                        world
                         x
                    x"))))

(test "cond"
      (lambda (t)
        (t.is (cond (else 10)) 10)
        (t.is (cond ((zero? 0) 10) (else 20)) 10)
        (t.is (cond ((zero? 10) 10) (else 20)) 20)
        (t.is (let ((alist '((a . 10) (b . 20) (c . 30))))
                (cond ((assoc 'b alist) => cdr) (else #f)))
              20)))

(test "filter"
      (lambda (t)
        (t.is (filter #/foo/ '(bar foo baz foo)) '(foo foo))
        (t.is (filter #/xxx/ '(bar foo baz foo)) '())
        (t.is (filter #/foo/ '("bar" "foo" "baz" "foo")) '("foo" "foo"))
        (t.is (filter odd? '(1 2 3 4)) '(1 3))
        (t.is (filter odd? '(0 0 0 0)) '())))
