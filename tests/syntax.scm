
;; A template identifier defined at TOP LEVEL by a macro is visible
;; under its plain name at the use site - the Chicken/Guile/most-R7RS
;; behaviour.
(define-syntax syntax-def
  (syntax-rules ()
    ((_ v)
     (define syntax/foo v))))

(syntax-def 77)

;; several expansions share the plain top-level binding (=> (1 2 3))
(define-syntax make-counter
  (syntax-rules ()
    ((_ name)
     (begin
       (define syntax/counter 0)
       (define (name)
         (set! syntax/counter (+ syntax/counter 1))
         syntax/counter)))))

(make-counter syntax/tick)
(make-counter syntax/tock)
(define syntax/counter-result (list (syntax/tick) (syntax/tick) (syntax/tock)))

;; a macro that both defines and uses the identifier internally
(define-syntax create-defuse
  (syntax-rules ()
    ((_ v)
     (begin
       (define syntax/defuse v)
       syntax/defuse))))

(create-defuse 42)

(test "hygiene"
      (lambda (t)
        (define result (let ((f (lambda (x) (+ x 1))))
                          (let-syntax ((f (syntax-rules ()
                                            ((_ x) x)))
                                       (g (syntax-rules ()
                                            ((_ x) (f x)))))
                            (list (f 1) (g 1)))))
         (t.is result '(1 2))))

(test "lambda"
      (lambda (t)
        (let ()
          (define-syntax foo
            (syntax-rules ()
              ((_ x ...) (lambda x ...))))

          (define-syntax test
            (syntax-rules ()
              ((_ x) (foo (z) (+ x z)))))

          (define add-3 (test (let ((z 1)) (+ z 2))))

          (t.is (list
                  (add-3 3)
                  (let ((z 10))
                    ((test z) 10)))
                '(6 20)))))

(test "complex hygiene"
      (lambda (t)
        (let ((result (let-syntax
                        ((or (syntax-rules ()
                               ((or) #f)
                               ((or e) e)
                               ((or e1 e2 ...)
                                (let ((temp e1))
                                  (if temp
                                      temp
                                      (or e2 ...)))))))
                        (let ((x #f)
                              (y 7)
                              (temp 8)
                              (let odd?)
                              (if even?))
                          (or x
                              (let temp)
                              (if y)
                              y)))))
        (t.is result 7))))

(test "let + return symbol"
      (lambda (t)
        (define result (let ((x 'outer))
                         (let-syntax ((m (syntax-rules () ((m) x))))
                           (let ((x 'inner))
                             (m)))))
        (t.is result 'outer)))


(test "quote expression"
      (lambda (t)
          (define-syntax stest
            (syntax-rules ()
              ((_ v . rest) '(default v))))


          (let-syntax ((stest (syntax-rules ()
                                ((_ v . rest) (cons 'v (stest . rest)))
                                ((_) '()))))
            (t.is (stest 5 4 3 2 1 0) '(5 default 4)))

          (letrec-syntax ((stest (syntax-rules ()
                                   ((_ v . rest) (cons 'v (stest . rest)))
                                   ((_) '()))))
            (t.is (stest 5 4 3 2 1 0) '(5 4 3 2 1 0)))))

(test "recursive or"
      (lambda (t)
         (define or_ (syntax-rules ()
                ((or) #f)
                ((or e) e)
                ((or e1 e2 ...)
                 (let ((temp e1))
                   (if temp
                       temp
                       (or_ e2 ...))))))

         (t.is (or_ #f #f #f #f 10) 10)
         (t.is (or_ #t #f #f) #t)
         (t.is (or_ 10) 10)
         (t.is (or_) #f)))

(test "rest (dot)"
      (lambda (t)
        (define result (let-syntax ((when (syntax-rules ()
                                            ((when test stmt1 . stmt2)
                                             (if test
                                                 (begin stmt1
                                                        . stmt2))))))
                         (define if #t)
                         (when if (set! if 'now) if)))
        (t.is result 'now)))

(test "double splice"
      (lambda (t)

        (define-syntax foo
          (syntax-rules ()
            ((foo (f1 ...) (f2 ...) . body-forms)
             '(f1 ... f2 ... . body-forms))))

        (t.is (foo (a b c d) (1 2 3 4) moe larry curly)
              '(a b c d 1 2 3 4 moe larry curly))))


(test "when syntax hygiene"
      (lambda (t)
        (define result (let-syntax ((when (syntax-rules ()
                                            ((when test stmt1 stmt2 ...)
                                             (if test
                                                 (begin stmt1
                                                        stmt2 ...))))))
                         (let ((if #t))
                           (when if (set! if 'now))
                           if)))
        (t.is result 'now)))

(test "function and macro"
      (lambda (t)

        (define even?
          (lambda (x)
            (or (= x 0) (odd? (- x 1)))))

        (define odd?
          (syntax-rules ()
            ((_ x) (not (even? x)))))

        (t.is (even? 10) #t)
        (t.is (even? 13) #f)))

(test "scope"
      (lambda (t)
        (let ()
          (define-syntax nil!
            (syntax-rules ()
              ((_ x)
               (set! x '()))))

          (let ((set! (lambda (x . rest) x))
                (x 10))
            (nil! x)
            (t.is x '())))))

(test "skip second item in list"
   (lambda (t)
     (define-syntax foo
       (syntax-rules () ((_ (a . (b . (c ...))) ...) '(foo (a c ... ) ...))))
     (t.is (foo (1 2 3 4 5) (6 7 8 9 10)) '(foo (1 3 4 5) (6 8 9 10)))))

(test "only cddr (list)"
   (lambda (t)

     (define-syntax foo
       (syntax-rules () ((_ (a b c ...) ...) '(foo (c ...) ...))))

     (t.is (foo) '(foo))
     (t.is (to.throw (foo 1)) #t)
     (t.is (to.throw (foo (1))) #t)
     (t.is (foo (1 2)) '(foo ()))
     (t.is (foo (1 2 3 4 5) (6 7 8 9 10)) '(foo (3 4 5) (8 9 10)))))

(test "only cddr (cons literals)"
   (lambda (t)

     (define-syntax foo
       (syntax-rules () ((_ (a . (b . (c ...))) ...) '(foo (c ...) ...))))

     (t.is (foo) '(foo))
     (t.is (to.throw (foo 1)) #t)
     (t.is (to.throw (foo (1))) #t)
     (t.is (foo (1 2)) '(foo ()))
     (t.is (foo (1 2 3 4 5) (6 7 8 9 10)) '(foo (3 4 5) (8 9 10)))))

(test "map on cddr"
   (lambda (t)

      (define-syntax foo
         (syntax-rules () ((_ x ...) (cons 'foo (map cddr '(x ...))))))

      (t.is (foo (1 2 3 4 5) (6 7 8 9 10)) '(foo (3 4 5) (8 9 10)))))

(test "extract 1st and 2nd items from list"
   (lambda (t)

      (define-syntax foo
         (syntax-rules () ((_ (a . (b . (c . ()))) ...) '(foo (a . c) ...))))

      (t.is (foo) '(foo))
      (t.is (foo (1 2 3)) '(foo (1 . 3)))
      (t.is (foo (1 2 3) (4 5 6)) '(foo (1 . 3) (4 . 6)))))

(test "extract 2nd elements from lists"
   (lambda (t)

      (define-syntax foo
         (syntax-rules () ((_ (a . (b . (c . ()))) ...) '(foo b ...))))

      (t.is (foo) '(foo))
      (t.is (to.throw (foo 1)) #t)
      (t.is (to.throw (foo (1))) #t)
      (t.is (to.throw (foo (1 2))) #t)
      (t.is (foo (1 2 3)) '(foo 2))
      (t.is (foo (1 2 3) (4 5 6)) '(foo 2 5))
      (t.is (foo (1 2 3) (4 5 6) (7 8 9)) '(foo 2 5 8))))

(test "should spread elements"
   (lambda (t)

      (define-syntax foo
         (syntax-rules ()
           ((_ (a . (b . (c . ()))) ...)
            '(foo a ... b ... c ...))))

      (t.is (foo) '(foo))
      (t.is (to.throw (foo 1)) #t)
      (t.is (to.throw (foo (1))) #t)
      (t.is (to.throw (foo (1 2))) #t)
      (t.is (foo (1 2 3) (4 5 6) (7 8 9)) '(foo 1 4 7 2 5 8 3 6 9))
      (t.is (foo (1 2 3)) '(foo 1 2 3))
      (t.is (foo (1 2 3) (4 5 6)) '(foo 1 4 2 5 3 6))))

(test "list quine"
  (lambda (t)
    (define-syntax foo
      (syntax-rules ()
        ((_ (x ...) ...)
         '(foo (x ...) ...))))

    (t.is (foo) '(foo))
    (t.is (to.throw (foo 1)) #t)
    (t.is (foo ()) '(foo ()))
    (t.is (foo (x)) '(foo (x)))
    (t.is (foo (x y)) '(foo (x y)))
    (t.is (foo (a b) (c d)) '(foo (a b) (c d)))
    ;; multiple groups where the inner ellipsis matches nothing must keep
    ;; the per-group structure, not collapse (regression: crashed with
    ;; "ellipis not transformed")
    (t.is (foo () ()) '(foo () ()))
    (t.is (foo (a) (b)) '(foo (a) (b)))))

(test "nested ellipsis with empty inner group (conde shape)"
  (lambda (t)
    ;; a leading fixed pattern var followed by an inner ellipsis, inside an
    ;; outer ellipsis - the shape miniKanren's `conde` expands to. When a
    ;; group's inner ellipsis is empty it used to drop later groups and leak
    ;; the ellipsis (#546 follow-up).
    (define-syntax test
      (syntax-rules ()
        ((_ (g0 g ...) ...) (list (list g0 g ...) ...))))

    (t.is (test (1)) '((1)))
    (t.is (test (1) (2)) '((1) (2)))
    (t.is (test (1) (2) (3)) '((1) (2) (3)))
    (t.is (test (1 2) (3)) '((1 2) (3)))
    (t.is (test (1) (2 3)) '((1) (2 3)))
    (t.is (test (1 2) (3 4)) '((1 2) (3 4)))))

(test "cons 1st and 2nd in lists"
  (lambda (t)

    (define-syntax foo
       (syntax-rules () ((_ (a b) ...)  '((a . b) ...))))

    (t.is (foo) '())
    (t.is (to.throw (foo 1)) #t)
    (t.is (to.throw (foo ())) #t)
    (t.is (to.throw (foo (1))) #t)

    (t.is (foo (1 2)) '((1 . 2)))
    (t.is (foo (1 2) (3 4)) '((1 . 2) (3 . 4)))
    (t.is (foo (1 2) (3 4) (5 6)) '((1 . 2) (3 . 4) (5 . 6)))))

(test "zip transformation"
  (lambda (t)

    (define-syntax foo
       (syntax-rules () ((_ (a ...) (b ...)) '((a . b) ...))))

    (t.is (to.throw (foo)) #t)
    (t.is (to.throw (foo 1)) #t)
    (t.is (to.throw (foo 1 1)) #t)
    (t.is (to.throw (foo (1))) #t)
    (t.is (to.throw (foo () () ())) #t)
    (t.is (foo (1) (2)) '((1 . 2)))
    (t.is (foo (1 2) (3 4)) '((1 . 3) (2 . 4)))
    (t.is (foo (1 2 3) (4 5 6)) '((1 . 4) (2 . 5) (3 . 6)))))

(test "merge lists"
      (lambda (t)
        (define-syntax merge
          (syntax-rules ()
            ((_) '())
            ((_ (foo ...) . rest)
             (append (list foo ...) (merge . rest)))))

        (t.is (to.throw (merge 1)) #t)
        (t.is (to.throw (merge 1 2)) #t)
        (t.is (merge) '())
        (t.is (merge (1 2 3)) '(1 2 3))
        (t.is (merge (1 2 3) (4 5 6)) '(1 2 3 4 5 6))
        (t.is (merge (1 2 3) (4 5 6) (7 8 9)) '(1 2 3 4 5 6 7 8 9))))

(test "identifiers"
      (lambda (t)
        (define-syntax let+
          (syntax-rules (==>)
            ((_ ((a ==> b) ...) . body)
             (let ((a b) ...) . body))))

        (t.is (let+ ((a ==> 1)
                     (b ==> 2))
                    (+ a b))
              3)))

(test "basic ellipsis (srfi-46)"
      (lambda (t)

        (define-syntax funcall
          (syntax-rules ::: ()
             ((_ name args :::) (name args :::))))

        (t.is (funcall list 1 2 3) '(1 2 3))))

(test "macro define function"
      (lambda (t)

        (define-syntax def
          (syntax-rules (==>)
            ((_ name ==> body ...)
             (define name (lambda body ...)))))

        (def square ==> (x) (* x x))
        (t.is (square 10) 100)))

(test "macro define list of functions"
      (lambda (t)

        (define-syntax defn
          (syntax-rules (==>)
            ((_ (name ==> body ...) ...)
             (begin
               (define name (lambda body ...))
               ...))))

        (defn (square ==> (x) (* x x))
              (add ==> (a b) (+ a b))
              (sum ==> a (apply + a)))
        (t.is (square (add 6 4)) 100)
        (t.is (sum 1 2 3) 6)))

(test "nested syntax-rules (srfi-46)"
      (lambda (t)

        (define-syntax list+
          (syntax-rules ::: ()
             ((_ args :::) '(args :::))))

        (define-syntax alias
          (syntax-rules ()
            ((_ name ref)
             (define-syntax name
               (syntax-rules ::: ()
                 ((_ args :::)
                  (ref args :::)))))))

        (alias list- list+)
        (t.is (list+ 1 2 3) '(1 2 3))
        (t.is (list- 4 5 6) '(4 5 6))))

(test "nested syntax-rules gensyms (srfi-46)"
      (lambda (t)

        (define result (let-syntax
                          ((f (syntax-rules ()
                                ((f ?e)
                                 (let-syntax
                                     ((g (syntax-rules ::: ()
                                           ((g (??x ?e) (??y :::))
                                            '((??x) ?e (??y) :::)))))
                                   (g (1 2) (3 4)))))))
                        (f :::)))

        (t.is result '((1) 2 (3) (4)))))

(test "tail of ellipsis (srfi-46)"
      (lambda (t)

        (define result (let-syntax
                          ((foo (syntax-rules ()
                                  ((foo ?x ?y ... ?z)
                                   (list ?x (list ?y ...) ?z)))))
                        (foo 1 2 3 4 5)))

        (t.is result '(1 (2 3 4) 5))

        (define result (let-syntax
                          ((foo (syntax-rules ()
                                  ((foo ?a ?b ... ?c ?d)
                                   (list ?a (list ?b ...) ?c ?d)))))
                        (foo 1 2 3 4 5)))

        (t.is result '(1 (2 3) 4 5))))

(test "rec macro (srfi-31)"
      (lambda (t)

        (define-syntax rec
          (syntax-rules ()
            ((rec (NAME . VARIABLES) . BODY)
             (letrec ( (NAME (lambda VARIABLES . BODY)) ) NAME))
            ((rec NAME EXPRESSION)
             (letrec ( (NAME EXPRESSION) ) NAME))))

        (define F (rec (F N)
                       ((rec (G K L)
                             (if (zero? K) L
                                 (G (- K 1) (* K L)))) N 1)))


        (t.is (F 10) 3628800)))

(test "join macros"
      (lambda (t)

        (define-syntax join_1
          (syntax-rules ()
            ((_ (foo ...) . x)
             (list foo ... . x))))

        (t.is (join_1 (1 2 3) 4) '(1 2 3 4))
        (t.is (join_1 (1 2 3) 4 5 6) '(1 2 3 4 5 6))

        (define-syntax join_2
          (syntax-rules ()
            ((_ (foo ...) x)
             (list foo ... x))))

        (t.is (join_2 (1 2 3) 4) '(1 2 3 4))
        (t.is (to.throw (join_2 (1 2 3) 4 5)) #t)))

(test "double ellipsis (SRFI-149)"
      (lambda (t)

        (define result (let-syntax
                           ((my-append
                             (syntax-rules ()
                               ((my-append (a ...) ...) '(a ... ...)))))
                         (my-append (1 2 3) (4 5 6))))

        (t.is result '(1 2 3 4 5 6))))

(test "nested macro with escape ellipsis"
      (lambda (t)
        (define-syntax define-for
          (syntax-rules ()
            ((_ symbol)
             (define-syntax symbol
               (syntax-rules ()
                 ((_ (var start end) body (... ...))
                  (let loop ((var start))
                    (if (<= var end)
                        (begin
                          body (... ...)
                          (loop (+ var 1)))))))))))

        (define-for loop)

        (let ((result (vector)))
          (loop (i 1 10)
                (result.push i))
          (t.is result #(1 2 3 4 5 6 7 8 9 10)))))

(test "triple elispsis (Gauche example)"
      (lambda (t)
        (define-syntax my-append
          (syntax-rules ()
            [(_ ((a ...) ...) ...)
             '(a ... ... ...)]))

        (t.is (my-append ((1 2) (3 4)) ((5) (6 7 8))) '(1 2 3 4 5 6 7 8))))

(test "my-let"
      (lambda (t)
        (define-syntax my-let
          (syntax-rules ()
            [(_ ((var init) ...) body ...)
             ((lambda (var ...) body ...) init ...)]))

        (t.is (my-let ((x 10) (y 20)) (+ x y)) 30)))

;; the matcher and the transcriber key their internal maps by identifier name;
;; an identifier that happens to name an Object.prototype member must not be
;; mistaken for an inherited JS property of those maps
(test "identifiers that shadow Object.prototype members"
      (lambda (t)
        (t.plan 3)
        (let-syntax ((q (syntax-rules ()
                          ((_) '(constructor toString valueOf hasOwnProperty ordinary)))))
          (t.is (q) '(constructor toString valueOf hasOwnProperty ordinary)))
        (let-syntax ((r (syntax-rules () ((_ constructor) '(constructor constructor)))))
          (t.is (r hello) '(hello hello)))
        (let-syntax ((s (syntax-rules () ((_ toString ...) '(toString ...)))))
          (t.is (s 1 2 3) '(1 2 3)))))

;; a repetition whose sub-template is a compound form, nested inside another
;; repetition - plain R7RS, every variable is used at its own ellipsis depth
(test "nested ellipsis over a compound sub-template"
      (lambda (t)
        (t.plan 3)
        (let-syntax ((f (syntax-rules () ((_ (a ...) ...) '(((a a) ...) ...)))))
          (t.is (f (1 2) (3 4)) '(((1 1) (2 2)) ((3 3) (4 4)))))
        (let-syntax ((f (syntax-rules () ((_ (a ...) ...) '(((a) ...) ...)))))
          (t.is (f (1 2) (3 4)) '(((1) (2)) ((3) (4)))))
        (let-syntax ((f (syntax-rules () ((_ (a b ...) ...) '((a ((b) ...)) ...)))))
          (t.is (f (x 1 2) (y 3 4)) '((x ((1) (2))) (y ((3) (4))))))))

(test.failing "lifted ellipsis (SRFI-149)"
      (lambda (t)
        (define result
          (let-syntax
              ((foo (syntax-rules ()
                      ((foo (a b ...) ...) '(((a b) ...) ...)))))
            (foo (bar 1 2) (baz 3 4))))

        (t.is result '(((bar 1) (bar 2)) ((baz 3) (baz 4))))))


(test "R6RS do macro"
       (lambda (t)
         (define-syntax do
           (syntax-rules ()
             ((do ((var init step ...) ...)
                (test expr ...)
                command ...)
              (letrec
                  ((loop
                    (lambda (var ...)
                      (if test
                          (begin
                            #f ; avoid empty begin
                            expr ...)
                          (begin
                            command
                            ...
                            (loop (do "step" var step ...)
                                  ...))))))
                (loop init ...)))
             ((do "step" x)
              x)
             ((do "step" x y)
              y)))

         (t.is (do ((vec (make-vector 5))
                    (i 0 (+ i 1)))
                 ((= i 5) vec)
                 (vector-set! vec i i))
               #(0 1 2 3 4))

         (t.is (let ((x '(1 3 5 7 9)))
                 (do ((x x (cdr x))
                      (sum 0 (+ sum (car x))))
                   ((null? x) sum)))
               25)))

;; foo foo ... should match single element foo ... should match ()
(test "R6RS unless & when macros"
       (lambda (t)

         (define-syntax when
           (syntax-rules ()
             ((when test result1 result2 ...)
              (if test
                  (begin result1 result2 ...)))))

         (define-syntax unless
           (syntax-rules ()
             ((unless test result1 result2 ...)
              (if (not test)
                  (begin result1 result2 ...)))))


         (t.is (when (> 3 2) 'foo) 'foo)
         (t.is (when (< 3 2) 'foo) #void) ;; unspecified

         (t.is (unless (> 3 2) 'less) #void) ;; unspecified

         (t.is (unless (< 3 2) 'foo) 'foo)))

;; guile example
(test "literal atoms"
       (lambda (t)
          (define-syntax define-matcher-macro
            (syntax-rules ()
              ((_ name lit)
               (define-syntax name
                 (syntax-rules ()
                  ((_ lit) #t)
                  ((_ else) #f))))))

             (define-matcher-macro is-literal-foo? "foo")

             (t.is (is-literal-foo? "foo") #t)
             (t.is (is-literal-foo? "bar") #f)
             (let ((foo "foo"))
                (t.is (is-literal-foo? foo) #f))))

(test "my-or hygiene"
      (lambda (t)

        (define-syntax my-or
          (syntax-rules ()
            ((my-or)
             #t)
            ((my-or exp)
             exp)
            ((my-or exp rest ...)
             (let ((t exp))
               (if t
                   t
                   (my-or rest ...))))))
         (t.is (let ((t #t)) (my-or #f t)) #t)))


(test "recursive do"
       (lambda (t)
         (define-syntax do
            (syntax-rules ()
              ((do ((var start inc) ...) (test) body ...)
               (do ((var start inc) ...) (test ()) body ...))
              ((do ((var start inc) ...) (test result) body ...)
               (begin
                  (let iter ((var start) ...)
                    (if test
                        result
                        (begin
                           body ...
                           (iter inc ...))))))))

          (t.is (do ((i 10 (- i 1)))
                    ((zero? i)))
                '())

          ;; working direct matching
          (t.is (let ((result '()))
                  (do ((i 10 (- i 1)))
                      ((zero? i) result)
                      (set! result (cons i result))))
                '(1 2 3 4 5 6 7 8 9 10))))


(test "should define nested syntax-rules"
      (lambda (t)
        ;; be-like-begin from R7RS spec file
        (define-syntax be-like-begin
          (syntax-rules ()
            ((be-like-begin name)
             (define-syntax name
               (syntax-rules ()
                 ((name expr (... ...))
                  (begin expr (... ...))))))))

        (be-like-begin sequence)
        (t.is (sequence 1 2 3 4) 4)

        (be-like-begin progn)
        (t.is (let* ((x 10)
                     (expr `(,x . ,x)))
                (progn
                 x
                 x
                 expr))
              '(10 . 10))))

(test "recursive call"
      (lambda (t)

        (define-syntax L
          (syntax-rules ()
            ((_) '())
            ((_ a b ...) (cons a (L b ...)))))

        (t.is (L 1 2 3) '(1 2 3))))

(test "should return list with ellipsis"
       (lambda (t)

         (define-syntax test
           (syntax-rules ()
             ((_) (... '...))))

         (t.is (test) '...)

         (define-syntax test
           (syntax-rules ()
             ((_) (test 1 2))
             ((_ arg ...) (list (cons arg (... '...)) ...))))

         (t.is (test 1 2 3) '((1 . ...) (2 . ...) (3 . ...)))
         (t.is (test) '((1 . ...) (2 . ...)))))


(test "should handle identifiers"
       (lambda (t)

         (define-syntax for
           (syntax-rules (in as)
             ((for element in list body ...)
              (map (lambda (element)
                      body ...)
                   list))
            ((for list as element body ...)
             (for element in list body ...))))

         (t.is (let ((result '()))
                 (for i in '(0 1 2 3 4)
                      (set! result (cons i result)))
                  result)
               '(4 3 2 1 0))

         (t.is (let ((result '()))
                 (for '(0 1 2 3 4) as i
                      (set! result (cons i result)))
                 result)
               '(4 3 2 1 0))))


(test "should define let*"
      (lambda (t)
        ;; source https://www.scheme.com/tspl2d/syntax.html#g2252
        (t.is (type let*) "macro")
        (define-syntax let*
          (syntax-rules ()
            ((_ () e1 e2 ...) (let () e1 e2 ...))
            ((_ ((i1 v1) (i2 v2) ...) e1 e2 ...)
             (let ((i1 v1))
               (let* ((i2 v2) ...) e1 e2 ...)))))
        (t.is (type let*) "syntax")
        (t.is (let* ()
                (+ 1 2))
              3)
        (t.is (let* ((x 10)
                     (y (+ x 2)))
                (+ x y))
              22)))

(test "scope + identifiers"
      (lambda (t)

        (define-syntax foo
          (syntax-rules (++)
            ((_ x ++ y)
             (list x 1 1 y))))

        (define (test)
          (let ((__ 10))
            (define-syntax foo
              (syntax-rules (__)
                ((_ x __ y)
                 (list x 1 1 y))))
            (foo 'a __ 2)))

        (t.is (test) (list 'a 1 1 2))

        (define (test)
          (define-syntax foo
            (syntax-rules (__)
              ((_ x __ y)
               (list x 1 1 y))))
          (define __ 10)
          (foo 'b __ 2))

        (t.is (test) (list 'b 1 1 2))

        (t.is (foo 1 ++ 2) '(1 1 1 2))))

(test "auxiliary literal matches when renamed by another macro"
      (lambda (t)
        ;; R7RS 4.3.2: an input identifier matches a pattern literal by
        ;; denotation, not surface name. When `bar` expands to (foo a else b),
        ;; hygiene renames `else` (an unbound auxiliary keyword) to a gensym;
        ;; it must still match foo's `else` literal.
        (define-syntax foo
          (syntax-rules (else)
            ((_ x else y) (if x x y))))

        (define-syntax bar
          (syntax-rules ()
            ((_ a b) (foo a else b))))

        (t.is (foo #f else 20) 20)
        (t.is (foo 5 else 20) 5)
        (t.is (bar #f 30) 30)
        (t.is (bar 7 30) 7)

        ;; also via cond's else/=> reached through a macro expansion - cond is
        ;; a define-macro that recognizes the renamed keywords with
        ;; free-identifier=?
        (define-syntax classify
          (syntax-rules ()
            ((_ a) (cond ((zero? a) 'zero) (else 'other)))))
        (t.is (classify 0) 'zero)
        (t.is (classify 10) 'other)

        (define-syntax double-if
          (syntax-rules ()
            ((_ a) (cond (a => (lambda (x) (* x 2))) (else 'no)))))
        (t.is (double-if 21) 42)
        (t.is (double-if #f) 'no)))

(test "free-identifier=?"
      (lambda (t)
        ;; identifiers compare by denotation, seeing through hygienic renaming
        (t.is (free-identifier=? 'else 'else) #t)
        (t.is (free-identifier=? 'else 'other) #f)
        (t.is (free-identifier=? 'car 'car) #t)   ; same global binding
        (t.is (free-identifier=? 5 'else) #f)     ; non-identifiers

        ;; a keyword renamed by a hygienic macro still equals the original
        (define-macro (renamed-else=? x) (free-identifier=? x 'else))
        (define-syntax via (syntax-rules () ((_) (renamed-else=? else))))
        (t.is (via) #t)))

(test "scope with rewriting"
      (lambda (t)
        ;; ref: https://www.cs.utah.edu/plt/scope-sets/
        (define self (letrec-syntax ([identity (syntax-rules ()
                                                 [(_ misc-id)
                                                  (lambda (x)
                                                    (let ([misc-id 'other])
                                                      x))])])
                       (identity x)))
        (t.is (self 10) 10)

        ;; racket macro
        (define-syntax define-syntax-rule
          (syntax-rules ()
            ((_ (name args ...) body)
             (define-syntax name (syntax-rules () ((name args ...) body))))))

        (define-syntax-rule (define-other-five misc-id)
          (begin
            (define x 5)
            misc-id))

        (t.is (to.throw (define-other-five x)) true)))

(test "define syntax macro inside syntax-macro"
      (lambda (t)

        (define-syntax def (syntax-rules () ((_ x y ) (define x y))))
        (define-syntax def-2 (syntax-rules () ((_ x y) (def x y))))

        (def foo 10)
        (def-2 bar 20)
        (t.is (+ foo bar) 30)))

(test "top-level macro-introduced define binds the plain name (R7RS)"
      (lambda (t)
        (t.is syntax/foo 77)
        (t.is syntax/counter-result '(1 2 3))
        (t.is syntax/defuse 42)

        ;; but an INTERNAL (lexical body) macro-define stays hygienic/private
        (define-syntax def-priv (syntax-rules () ((_ y) (define priv y))))
        (t.is (to.throw (let () (def-priv 10) priv)) #t)))

(test "free variables (lazy reference)"
      (lambda (t)
        (define-syntax def (syntax-rules ()
                             ((_ foo bar)
                              (begin
                                (define foo bar)
                                (t.is hello 10)))))

        (def hello 10)
        (t.is hello 10)))

;; R7RS 4.3: a template can both DEFINE and REFERENCE a macro-introduced
;; identifier. Both are renamed to the same gensym, so the reference has to see
;; the definition - the lazy-alias placeholder created for the free identifier
;; must not shadow it (see the jabberwocky example in the R7RS test suite).
(test "macro-introduced identifier defined and referenced by the expansion"
      (lambda (t)
        (t.plan 2)
        ;; the definition is reached through a nested macro
        (let ()
          (define-syntax jabberwocky
            (syntax-rules ()
              ((_ hatter)
               (begin
                 (define march-hare 42)
                 (define-syntax hatter
                   (syntax-rules () ((_) march-hare)))))))
          (jabberwocky mad-hatter)
          (t.is (mad-hatter) 42))
        ;; forward reference: `gg` is used before its define
        (let ()
          (define-syntax ffoo
            (syntax-rules ()
              ((_ ff)
               (begin
                 (define (ff x) (gg x))
                 (define (gg x) (* x x))))))
          (ffoo ff)
          (t.is (ff 10) 100))))

(test "should pass body from macro to function"
      (lambda (t)

        (define-syntax foo
          (syntax-rules ()
            ((_ . bar) (baz . bar))))

        (define (baz . args) args)

        (t.is (foo 1 2 3) '(1 2 3))))

(test "should find last item in list"
      (lambda (t)

        (define-syntax last
          (syntax-rules ()
            ((_ ()) ())
            ((_ (x)) x)
            ((_ (x ... y)) y)))

        (t.is (last (1 2 3 4 5 6)) 6)
        (t.is (last (1)) 1)
        (t.is (last ()) ())
        (t.is (to.throw (last)) true)))

(test "should find last item in argument list"
      (lambda (t)

        (define-syntax last-arg
          (syntax-rules ()
            ((_) ())
            ((_ x) x)
            ((_ x ... y) y)))

        (t.is (last-arg 1 2 3 4 5 6) 6)
        (t.is (last-arg 1) 1)
        (t.is (last-arg) ())
        (t.is (to.throw (last)) true)))


(test "should skip cons with identifier"
      (lambda (t)
        (define-syntax foo
          (syntax-rules (<>)
            ((_ <> . b) ())
            ((_ a . b) (cons a b))))

        (t.is (foo 1) '(1))
        (t.is (foo 1 . 2) '(1 . 2))))

(test "should define nested syntax with variable from outside as identifier"
      (lambda (t)

        (define-syntax foo (syntax-rules ()
                     ((_ bar)
                      (let ()
                        (define-syntax baz
                          (syntax-rules (bar)
                            ((_ x) ())))
                        (baz bar)))))

        (t.is (foo 10) ())))

(test "should expand in nested syntax into variable from parent syntax"
      (lambda (t)
        (define-syntax foo (syntax-rules ()
                     ((_ bar quux)
                      (let ()
                        (define-syntax baz
                          (syntax-rules (bar)
                            ((_ x) (list quux))))
                        (baz bar)))))

        (t.is (foo 1 "hello") '("hello"))))

(test "should expand nested macro with ellipsis as identifier from parent"
      (lambda (t)

        (define-syntax foo
          (syntax-rules (ellipsis)
            ((_)
             (let ()
               (define-syntax foo
                 (syntax-rules ellipsis ()
                   ((_ x ellipsis)
                    (list x ellipsis))))
               (foo 1 2 3)))))

        (t.is (foo) '(1 2 3))

        ;; recursive case
        (define-syntax foo
          (syntax-rules (ellipsis)
            ((_)
             (let ()
               (define-syntax foo
                 (syntax-rules ellipsis ()
                   ((_) ())
                   ((_ x) (list x))
                   ((_ x ellipsis)
                    (list (foo x) ellipsis))))
               (foo 1 2 3)))))

        (t.is (foo) '((1) (2) (3)))))

(test "should set! a free identifier's original binding (hygiene)"
      (lambda (t)

        ;; set! on a free (template) identifier must mutate the ORIGINAL
        ;; binding it refers to, not a hygienic throwaway copy
        (define *g* 0)
        (define-syntax setg
          (syntax-rules ()
            ((_) (set! *g* 5))))
        (setg)
        (t.is *g* 5)

        ;; referential transparency: the free `*g*` refers to the binding
        ;; visible where the macro was defined (the global), not a same-named
        ;; local at the use site
        (define *h* 0)
        (define-syntax seth
          (syntax-rules ()
            ((_) (set! *h* 5))))
        (let ((*h* 99))
          (seth)
          (t.is *h* 99))
        (t.is *h* 5)

        ;; set! on a macro argument mutates the caller's variable
        (define n 1)
        (define-syntax inc!
          (syntax-rules ()
            ((_ v) (set! v (+ v 1)))))
        (inc! n)
        (t.is n 2)))

(test "should preserve identity of a value returned from a macro"
      (lambda (t)

        ;; a macro that returns a free variable must return the SAME object,
        ;; not a copy - clear_gensyms must not deep-copy the result value
        (define *d* (list 'done))
        (define-syntax getd
          (syntax-rules ()
            ((_) *d*)))
        (t.is (eq? (getd) *d*) #t)
        (t.is (eq? (getd) (getd)) #t)

        ;; mutating the original is visible through the macro result
        (set-car! *d* 'changed)
        (t.is (car (getd)) 'changed)))

(test "should ignore ellipsis in middle for 2 elements"
      (lambda (t)
        ;; code for define-values from R7RS spec
        ;; macro defined in lib/R7RS.scm

        (let ()
          (define-values (x y) (values 1 2))
          (t.is (+ x y) 3))

        (let ()
          (define-values (x y z) (values 1 2 3))
          (t.is (+ x y z) 6))

        (let ()
          (define-values (x) (values 1))
          (t.is x 1))))

(test "swap macro"
      (lambda (t)
        ;; example from book Sketchy Scheme by Nils M Holm
        (define-syntax swap
          (syntax-rules ()
            ((_ (x y) ...)
             (list (quote (y x)) ...))))

        (t.is (swap) '())
        (t.is (swap (1 2)) '((2 1)))
        (t.is (swap (1 2) (3 4)) '((2 1) (4 3)))))

(test "reverse-syntax macro"
      (lambda (t)
        ;; example from book Sketchy Scheme by Nils M Holm
        (define-syntax reverse-syntax
          (syntax-rules ()
            ((_ lst)
             (reverse-syntax lst ()))
            ((_ () r) r)
            ((_ (a . d) r)
             (reverse-syntax d (a . r)))))

        (t.is (reverse-syntax (1 2 cons)) '(2 . 1))
        (t.is (reverse-syntax (1 2 3 4 5 list)) '(5 4 3 2 1))))

(test "duplicated expansion"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ (a ...) ...)
             (list (list (list a ...) (list a ...)) ...))))

        (t.is (foo (1 2 3) (4 5 6))
              '(((1 2 3) (1 2 3)) ((4 5 6) (4 5 6))))))


(test "revese args"
      (lambda (t)
        (define-syntax reverse
          (syntax-rules ()
            ((_) ())
            ((_ x ... y) (cons y (reverse x ...)))))

        (t.is (reverse 1 2 3 4 5) '(5 4 3 2 1))))

(test "R7RS multiple ellipsis extensions"
      (lambda (t)

        ;; source https://practical-scheme.net/gauche/man/gauche-refe/Hygienic-macros.html
        (define-syntax my-append
          (syntax-rules ()
            [(_ (a ...) ...)
             '(a ... ...)]))

        (t.is (my-append (1 2 3) (4) (5 6)) '(1 2 3 4 5 6))

        (define-syntax my-append2
          (syntax-rules ()
            [(_ ((a ...) ...) ...)
             '(a ... ... ...)]))

        (t.is (my-append2 ((1 2) (3 4)) ((5) (6 7 8))) '(1 2 3 4 5 6 7 8))))

(test "method on pattern symbol"
      (lambda (t)
        (define-syntax let*-values
            (syntax-rules ()
               ((_ ((bind values)) body ...)
                (apply (lambda bind
                         body ...)
                       (vector->list (values.valueOf))))))

        (t.is (let*-values (((a b c) (values 1 2 3)))
                (+ a b c))
              6)))


;; ref: https://stackoverflow.com/a/64659565/387194
(test "alist"
      (lambda (t)
        (define-syntax alist
          (syntax-rules ()
            ((_) ())
            ((_ a b) (list (cons a b)))
            ((_ x y z ...)
             (cons (cons x y) (alist z ...)))))

        (t.is (alist "foo" 1 "bar" 2 "baz" 3)
              '(("foo" . 1) ("bar" . 2) ("baz" . 3)))))

(test "alist + rest"
      (lambda (t)
        (define-syntax alist
          (syntax-rules ()
            ((_) ())
            ((_ a b) (list (cons a b)))
            ((_ x y . rest)
             (cons (cons x y) (alist . rest)))))

        (t.is (alist "foo" 1 "bar" 2 "baz" 3)
              '(("foo" . 1) ("bar" . 2) ("baz" . 3)))))

(test "nested _"
       (lambda (t)
         ;; %foo is defined inside foo, so its literals `foo`/`bar` are renamed
         ;; to gensyms by foo's expansion. A use-site `foo` (also renamed to the
         ;; same gensym) must still match the literal - the input and the literal
         ;; denote the same binding (the `foo` macro), even though it lives in an
         ;; interaction env rather than the base global env.
         (define-syntax foo
           (syntax-rules ()
             ((_)
              (let ()
                (define-syntax %foo
                  (syntax-rules (foo bar)
                    ((_ (foo))
                     "foo")
                    ((_) "bar")
                    ((_ x)
                     'x)))
                (list (%foo (foo))
                      (%foo (10))
                      (%foo bar)
                      (%foo))))))

         (t.is (foo) '("foo" (10) bar "bar"))))

;; Like "nested _", but the matched literal `foo` also appears in the
;; template's QUOTED output and the result is delivered by a side effect
;; (set!). Identifiers inside quote are literal data and must not be
;; hygiene-renamed, otherwise the gensym `#:foo` would leak into `result`
;; (clear_gensyms only fixes up a macro's return value, not set! data).
(test "nesting, renaming and scope"
       (lambda (t)
         (let ((result 10))
           (define-syntax foo
             (syntax-rules ()
               ((_)
                (let ()
                  (define-syntax %foo
                    (syntax-rules (foo bar)
                      ((__ (foo))
                       (set! result '(foo)))
                      ((__ x)
                       (set! result 'x))))
                  (%foo (foo))))))
           (foo)
           (t.is result '(foo)))))

(test "nested syntax-rules scope conflict"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ bar)
             (let ()
               (define-syntax %foo
                 (syntax-rules (bar)
                   ((_ bar x)
                    (list "foo" x))))
               (%foo bar 10)))))

        (t.is (foo x) '("foo" 10))

        (define-syntax foo
          (syntax-rules ()
            ((_ x)
             (let ()
               (define-syntax %foo
                 (syntax-rules (bar)
                   ((_ (bar) x)
                    (list "foo" x))))
               (%foo (bar) 10)))))

        (t.is (foo 10) '("foo" 10))))

(test "nested syntax-rules literal from outer pattern variable"
      (lambda (t)
        ;; a nested macro's literal that is the outer macro's pattern variable
        ;; is substituted into the literals list, and matched by IDENTITY - so a
        ;; like-named pattern variable is not mistaken for it
        (define-syntax outer
          (syntax-rules ()
            ((_ ph body)
             (let ()
               (define-syntax inner
                 (syntax-rules (ph)
                   ((_ ph) 'is-ph)
                   ((_ x) 'not-ph)))
               (inner body)))))

        (t.is (outer PH PH) 'is-ph)
        (t.is (outer PH other) 'not-ph)))

(test "should throw error on missing ellipsis symbol"
      (lambda (t)
        (t.is
         (to.throw
          (define-syntax foo
            (syntax-rules (:c)
              ((_ x ...)
               (letrec-syntax ((bar (syntax-rules <:::> (:c)
                                                  ((_ x)
                                                   (print x))
                                                  ((_ a b <:::>)
                                                   (begin
                                                     (display a)
                                                     (display " ")
                                                     (bar b <:::>))))))
                 (bar x ...)))))
          (foo 1 2 3))
         true)))

(test "should create macro with dot notation as pattern variable"
      (lambda (t)
        (let* ((input #(1 0.1 2 3 10e-1))
               (fn (lambda (x) (+ x 1)))
               (expect (input.map fn)))
          (let-syntax ((foo (syntax-rules ()
                              ((_ x)
                               (x.map fn)))))
            (t.is (foo input) expect)))))

(test "should work with dot notation in lambda inside syntax-rules"
      (lambda (t)
        (let* ((input '(1 0.1 2 3 10e-1))
               (expect (map (lambda (x) (x.isFloat)) input)))
          (let-syntax ((foo (syntax-rules ()
                              ((_)
                               (lambda (num) (num.isFloat))))))
            (let ((is-float (foo)))
              (t.is (map is-float input) expect))))))

(test "refsh macro"
      (lambda (t)
        (define-syntax fresh
          (syntax-rules ()
            ((_ (sym ...) expr exprs ...)
             (let ((sym (if #f #f)) ...)
               expr exprs ...))))

        (t.is (fresh (a b c) (list a b c))
              (list #void #void #void))))

(test "macro from Petrofsky"
      (lambda (t)
        ;; https://groups.google.com/g/comp.lang.scheme/c/FB1HgUx5d2s
        (t.is (letrec-syntax ((foo (syntax-rules (foo) ((_ foo) #t) ((_ x) #f))))
                (foo foo))
              #t)
        (define foo #null)
        (t.is (letrec-syntax ((foo (syntax-rules (foo) ((_ foo) #t) ((_ x) #f))))
                (foo foo))
              #t)))

(test "set! overwrites a macro binding (dynamic)"
      (lambda (t)
        ;; LIPS is dynamic: set! on a syntactic keyword overwrites the binding
        ;; with the value (like Gauche; Guile errors instead). The name is then
        ;; an ordinary variable, so using it in operator position is an error.
        (define-syntax h
          (syntax-rules ()
            ((h 2) -3)))
        (set! h 42)
        (t.is h 42)
        (t.is (to.throw (h 2)) #t)))

(test "let-syntax and set! of definition"
      (lambda (t)
        ;; https://github.com/jcubic/lips/issues/172
        ;; Referential transparency: f's `g` denotes the macro g as it was at
        ;; f's DEFINITION, captured then - so (f 1) -> (g 2) still expands to -3
        ;; even though a later set! overwrote g with a function.
        (define-syntax g
          (syntax-rules ()
            ((g 2) -3)))

        (t.is (let-syntax ((f (syntax-rules ()
                          ((f 1) (g 2)))))
                (set! g (lambda (x) -1000))
                (f 1))
              -3)

        ;; the overwrite is still visible directly: g now denotes the function
        (t.is (g 42) -1000)))

(test "syntax-rules -> syntax-rules"
      (lambda (t)
        ;; source: https://srfi.schemers.org/srfi-147/srfi-147.html
        (define-syntax syntax-rules*
          (syntax-rules ()
            ((syntax-rules* (literal ...) (pattern . templates) ...)
             (syntax-rules (literal ...) (pattern (begin . templates)) ...))
            ((syntax-rules* ellipsis (literal ...) (pattern . templates) ...)
             (syntax-rules ellipsis (literal ...) (pattern (begin . templates)) ...))))

        (t.is (let-syntax
                  ((foo
                    (syntax-rules* ()
                                   ((foo a b)
                                    (define a 1)
                                    (define b 2)))))
                (foo x y)
                (list x y))
              '(1 2))))

(test "syntax-parameterize (SRFI-139)"
      (lambda (t)

         (define-syntax-parameter it
           (syntax-rules ()
             ((_ . _)
              (syntax-error "it used outside of a aif"))))

        (define-syntax aif
          (syntax-rules (aux)
            ((_ aux test x y ...)
             (let ((value test))
               (syntax-parameterize
                ((it (syntax-rules ()
                       ((it) value))))
                (if value
                    x
                    y ...))))
            ((_ test true)
             (aif aux test true))
            ((_ test true false)
             (aif aux test true false))))

        (let ((alist '((foo . 10) (bar . 20))))
          (t.is (aif (assoc 'foo alist) (cdr (it)))
                10)
          (t.is (aif (assoc 'x alist) (cdr (it)))
                (if #f #f)))))

(test "should throw a proper error on not matched syntax"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ var1 ... var2)
             (begin
               (print var1)
               ...
               (print var2)))))

        (t.is (Boolean (--> (try (foo) (catch (e) e.message))
                            (match #/^syntax-rules: no matching syntax in macro/)))
              #t)))

(test "should match pattern (_ () var1 ... var2) #244"
      (lambda (t)
        (t.plan 1)
        (define-syntax foo
          (syntax-rules ()
            ((_ () var1 ... var2)
             (begin
               (string-append var1 " ")
               ...
               var2))))

        (foo () "a" "b")
        (foo () "x")
        (t.is #t #t)))

(test "recursive use of free variable hygiene #288"
      (lambda (t)
        (define-syntax call/mv
          (syntax-rules ()
            ((call/mv consumer producer1 ...)
             (letrec-syntax
                 ((aux (syntax-rules ::: ()
                         ((aux %consumer () ((%producer1 args1) :::))
                          (let-values (((proc) %consumer)
                                       (args1 %producer1) :::)
                            (apply proc (append args1 :::))))
                         ((aux %consumer (%producer1 producer2 :::) (temp :::))
                          (aux %consumer (producer2 :::) (temp ::: (%producer1 args1)))))))
               (aux consumer (producer1 ...) ())))))


        (t.is (call/mv string (values #\a #\b) (values #\c #\d)) "abcd")))

(test "SRFI-147"
      (lambda (t)
        (define-syntax syntax-rules*
          (syntax-rules ()
            ((syntax-rules* (literal ...) (pattern . templates) ...)
             (syntax-rules (literal ...) (pattern (begin . templates)) ...))
            ((syntax-rules* ellipsis (literal ...) (pattern . templates) ...)
             (syntax-rules ellipsis (literal ...) (pattern (begin . templates)) ...))))

        (let-syntax ((foo
                      (syntax-rules* ()
                        ((foo a b)
                         (define a 1)
                         (define b 2)))))
          (foo x y)
          (t.is (list x y) '(1 2)))))

(test "ellipsis + improper list"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ (foo bar ... . baz))
             '(foo baz))))

        (t.is (foo (a . b)) '(a b))))

(test "recursive hygiene with same symbol"
      (lambda (t)
        (define-syntax foo
          (syntax-rules (aux)
            ((_ (arg more ...))
             (foo aux (arg more ...) ()))
            ((_ aux () ((operand1 arg1) ...))
             (let ((arg1 operand1) ...)
               (list arg1 ...)))
            ((_ aux (operand1 operand2 ...) (temp ...))
             (foo aux (operand2 ...) (temp ... (operand1 arg1))))))

        (t.is (foo (10 20)) '(10 20))))

(test "recursive hygiene with nested syntax-rules"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ (arg more ...))
             (letrec-syntax ((aux (syntax-rules ::: ()
                                    ((aux () ((operand1 arg1) :::))
                                     (let ((arg1 operand1) :::)
                                       (list arg1 :::)))
                                    ((aux (operand1 operand2 :::) (temp :::))
                                     (aux (operand2 :::) (temp ::: (operand1 arg1)))))))
               (aux (arg more ...) ())))))

        (t.is (foo (10 20)) '(10 20))))

(test "cons spread"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ (var1 ... . var*))
             '(var1 ... var*))))

        (t.is (foo (x . y)) '(x y))))

(test "symbol after spread with ()"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ x () ((a b) ...) z)
             '(let ()
                (x (a b) ... z)
                (foo b ... args)))))

        (t.is (foo (print x) () () (display x))
              '(let () ((print x) (display x)) (foo args)))

        (define-syntax foo
          (syntax-rules ()
            ((_ x () ((a b) ...) z)
             '(let ()
                (x (a b) ... z)
                (foo (a ...) (b ...) args)))))

        (t.is (foo (print x) () () (display x))
              '(let () ((print x) (display x)) (foo () () args)))))

(test "spread tail"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ ((p ...) . body))
             '(apply (lambda (p ...) . body)
                     args))
            ((_ ((p ... . tail) . body))
             '(apply (lambda (p ... . tail) . body)
                     args))))

        (t.is (foo ((lis transducer . transducers) (display x)))
              '(apply (lambda (lis transducer . transducers) (display x)) args))))

(test "multiple values after ellipsis"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ (a ... b c) d ...)
             (list a ... b c d ...))))

        (t.is (foo (1 2 3 'x 'y) "foo" "bar" "baz")
              '(1 2 3 x y "foo" "bar" "baz"))))

;; ref: https://stackoverflow.com/q/37644555/387194
(test "identifier with variable"
      (lambda (t)
        (define-syntax hello
          (syntax-rules (in)
            ((_ name in world) (format "Hello ~a in ~a" name world))
            ((_ in name) (format "Hello ~a in here" name))))

        (define in "inside")
        (t.is (hello "me" in in)
              "Hello me in inside")))

;; ref: https://practical-scheme.net/gauche/man/gauche-refe/Hygienic-macros.html#Syntax_002drules-macro-transformer
(test "let shadow identifier (1)"
      (lambda (t)
        (define-syntax if+
          (syntax-rules (then else)
            ((_ test then expr1 else expr2) (if test expr1 expr2))))

        (define else #f)
        (let ((x 10))
          (t.is (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2))
                5))

        (t.is (to.throw (let ((else #f) (x 10))
                          (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2))))
              #t)))

(test "let shadow identifier (2)"
      (lambda (t)
        (define else #f)
        (define-syntax if+
          (syntax-rules (then else)
            ((_ test then expr1 else expr2) (if test expr1 expr2))))

        (let ((x 10))
          (t.is (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2))
                5))

        (t.is (to.throw (let ((else #f) (x 10))
                          (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2))))
              #t)))

(test "nested spread + leftover"
      (lambda (t)
        (define-syntax quux
          (syntax-rules ()
            ((_ (x ... a b) ...)
             '((x ... b) ...))))

        (t.is (quux (1 2 3 4) (5 6 7 8) (9 10 11 12))
              '((1 2 4) (5 6 8) (9 10 12)))))

(test "list as last element after ellipsis"
      (lambda (t)
        (define-syntax quux
          (syntax-rules ()
            ((_ (x ... (a ...)) ...)
             '((a ...) ...))))

        (t.is (quux (1 2 3 (1 2 3))
                     (5 6 7 (8))
                     (9 10 11 (12)))
              '((1 2 3) (8) (12)))

        (define-syntax quux
          (syntax-rules ()
            ((_ (x ... (a ...)) ...)
             '(a ... ...))))

        (t.is (quux (1 2 3 (1 2 3))
                    (5 6 7 (8))
                    (9 10 11 (12)))
              '(1 2 3 8 12))))

(test "helper macro pattern"
      (lambda (t)
        (define-syntax foo
          (syntax-rules (aux)
            ((_ (x ... (a ...) (b ...)) ...)
             (foo aux (a ... b ...) ...))
            ((_ aux (a ...) (b ...))
             '(a ... b ...))))

        (t.is (foo (1 2 (a b) (c d)) (3 4 (e f) (g h)))
              '(a b c d e f g h))))

(test "vectors as symbols"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ sym ...)
             (list sym ...))))

        (t.is (foo #(1 2) #(3 4)) '(#(1 2) #(3 4)))))

(test "make-vector"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ #(x ...) ...)
             (vector x ... ...))))

        (t.is (foo #(1 2) #(3 4))
              #(1 2 3 4))))

(test "vector and symbol + rest"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ #(a b ...) ...)
             (vector (list a b ...) ...))))

        (t.is (foo #(1 2 3) #(4 5 6))
              #((1 2 3) (4 5 6)))))

(test "vector 3 ellipsis"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((_ #(#(a b ...) ...) ...)
             (vector '(a b ...) ... ...))))

          (t.is (foo #(#(1 2 3) #(4 5 6)) #(#(1 2)))
                #((1 2 3) (4 5 6) (1 2)))))

(test "vector ellipsis + symbols after"
      (lambda (t)
        (define-syntax quux
          (syntax-rules ()
            ((_ #(a b ... z) ...)
             (vector 'z ...))))

        (t.is (quux #(1 2 3) #(4 5 6) #(7 8 9))
              #(3 6 9))

        (define-syntax quux
          (syntax-rules ()
            ((_ #(x ... a b) ...)
             (vector '(a b) ...))))

        (t.is (quux #(1 2 3 4) #(5 6 7 8) #(9 10 11 12))
              #((3 4) (7 8) (11 12)))

        (define-syntax quux
          (syntax-rules ()
            ((_ #(x ... a b) ...)
             (vector '(x ...) ...))))

        (t.is (quux #(1 2 3 4) #(5 6 7 8) #(9 10 11 12))
              #((1 2) (5 6) (9 10)))))

(test "simple vector spread"
      (lambda (t)
        (define-syntax quux
          (syntax-rules ()
            ((_ #(x ... a b) ...)
             #(b ...))))

        (t.is (quux #(1 2 3 4) #(5 6 7 8) #(9 10 11 12))
              #(4 8 12))))

(test "recursive flatten"
      (lambda (t)
        (define-syntax flatten
          (syntax-rules (aux reverse)
            ((_ xs)
             (flatten aux xs ()))
            ((_ aux ((xs ...) ys ...) (result ...))
             (flatten aux (xs ... ys ...) (result ...)))
            ((_ aux (x xs ...) (result ...))
             (flatten aux (xs ...) (x result ...)))
            ((_ aux () (result ...))
             (flatten reverse (result ...) ()))
            ((_ reverse () (result ...))
             '(result ...))
            ((_ reverse (x xs ...) (result ...))
             (flatten reverse (xs ...) (x result ...)))))

        (t.is (flatten ((1 2 (a b) (c d)) (3 4 (e f) (g h))))
              '(1 2 a b c d 3 4 e f g h))))

(test "let-slim"
      (lambda (t)
        ;; ref https://stackoverflow.com/a/56419718/387194
        (define-syntax let-slim
          (syntax-rules (pair)
            ((_ pair bindings () body)
             (let bindings . body))
            ((_ pair (acc ...) (k v . rest) body)
             (let-slim pair (acc ... (k v)) rest body))
            ((_ (elements ...) . body)
             (let-slim pair () (elements ...) body))))

        (t.is (let-slim (x 10 y 20)
                        (+ x y))
              30)))

(test "undswap"
      (lambda (t)
        ;; ref: https://stackoverflow.com/a/58965190/387194
        (define-syntax undswap
          (syntax-rules (_)
            ((undswap val (e ...))
             ((undswap val e) ...))
            ((undswap val _) val)
            ((undswap val e) e)))

        (t.is (undswap 3 (if _ (+ 3 _ )))
              6)))

(test "alist into code"
      (lambda (t)
        (define-syntax alist
          (syntax-rules ()
            ((_)
             '())
            ((_ key value . rest)
             (cons (cons key value) (alist . rest)))))

        (t.is (alist 'foo 10 'bar 20 'baz 30)
              '((foo . 10) (bar . 20) (baz . 30)))))

(test "alist literal"
      (lambda (t)
        ;; ref: https://stackoverflow.com/a/64672095/387194
        (define-syntax alist
          (syntax-rules (alist-builder)
            ((_ alist-builder () (results ...))
             '(results ...))
            ((_ alist-builder (a) . rest)
             (raise 'bad-alist))
            ((_ alist-builder (a b rest ...) (results ...))
             (alist alist-builder (rest ...) (results ... (a . b))))
            ((_ a ...) (alist alist-builder (a ...) ()))))

        (t.is (alist foo 10 bar 20 baz 30)
              '((foo . 10) (bar . 20) (baz . 30)))))

(test "nested syntax rules (SRFI-239)"
      (lambda (t)
        (define-syntax foo
          (syntax-rules ()
            ((foo expr clauses ...)
             (let-syntax ((clause
                           (syntax-rules ::: (_ pair null doted matched)
                             ((clause obj pair n d ((_ . _) body1 ::: body2) remaining :::)
                              (if (pair? obj)
                                  (begin body1 ::: body2))))))
               (let ((obj expr))
                 (clause obj pair null doted clauses ...))))))

        (t.is (foo '(1 2) ((_ . _) 'pair)) 'pair)))

(test "ellipsis maps into #void"
      (lambda (t)
        (define-syntax when
          (syntax-rules ()
            ((_ test body ...)
             (let ((tmp test))
               (if tmp
                   (begin
                     body ...))))))

        (t.snapshot (macroexpand '(when (assoc 'bar alist) #void)))))

(test "let and syntax-parameterize hygiene #356"
      (lambda (t)
        (define-syntax-parameter it (syntax-rules () ((_) (syntax-error "Use outside aif"))))

        (define-syntax awhen
          (syntax-rules ()
            ((_ test body ...)
             (let ((tmp test))
               (syntax-parameterize
                ((it (syntax-rules ()
                       ((__) tmp))))
                (if tmp
                    (begin
                      body ...)))))))

        (t.is (let ((alist '((foo . "lorem") (bar . "ipsum") (baz . "dolor")))
                    (begin (lambda () (throw 'ZONK))))
                (awhen (assoc 'bar alist) "msg"))
              "msg")))

(test "improper pattern"
      (lambda (t)
        (define-syntax f
          (syntax-rules ()
            ((f a ... x . y)
             (let ((output (vector)))
               (begin
                 (begin
                   (output.push (list a x y)))  ...)
               output))))

        (t.is (f 10 20 30 'a 'b)
              #((10 b ()) (20 b ()) (30 b ()) (a b ())))))

(test "global set! var hygiene"
      (lambda (t)
        (define *g* 0)

        (define-syntax setg
          (syntax-rules ()
            ((_) (set! *g* 5))))

        (setg)

        (t.is *g* 5)))

(test "Identifiers in syntax-rules can't be shadowed by local variables #291"
      (lambda (t)
        (t.is (to.throw (eval '(begin
                                 (define-syntax if+
                                   (syntax-rules (then else)
                                     ((_ test then expr1 else expr2) (if test expr1 expr2))))

                                 (let ((else #f) (x 10))
                                   (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2))))
                              (--> (interaction-environment) (inherit 'test-291a))))
              #t)

        (t.is (eval '(begin
                       (define-syntax if+
                         (syntax-rules (then else)
                           ((_ test then expr1 else expr2) (if test expr1 expr2))))

                       (define else #f)
                       (let ((el_se #f) (x 10))
                         (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2))))
                    (--> (interaction-environment) (inherit 'test-291b)))
              5)))

;; R7RS 4.3.2: the underscore `_` is a wildcard - it matches any input and
;; creates no binding.
(test "underscore is a non-binding wildcard"
      (lambda (t)
        (define-syntax second
          (syntax-rules ()
            ((_ _ x _) x)))
        ;; the two _ positions match but do not capture anything
        (t.is (second 1 2 3) 2)))

;; R7RS 4.3.2: `_` in a template is the literal symbol `_`, not a pattern
;; variable - it is transcribed verbatim and never renamed for hygiene.
(test "underscore in template is the literal symbol"
      (lambda (t)
        (define-syntax quote-underscore
          (syntax-rules ()
            ((_ x) (list (quote _) x))))
        (t.is (quote-underscore 5) '(_ 5))))

;; The keyword position of a pattern is never matched as a literal, even when
;; `_` is declared a literal identifier (this is what SRFI-197 relies on).
(test "underscore literal does not break the keyword position"
      (lambda (t)
        (define-syntax pick
          (syntax-rules (_)
            ;; keyword is `pick`; `_` is a literal used inside the pattern
            ((pick (a _ b)) (list 'has-underscore a b))
            ((pick (a b)) (list 'plain a b))))
        (t.is (pick (1 _ 2)) '(has-underscore 1 2))
        (t.is (pick (1 2)) '(plain 1 2))))

;; A trailing ellipsis that matches zero items must still assign the single
;; remaining element to the fixed trailing pattern - regression for a list
;; built by an accumulating recursive macro and re-matched with (x ... last).
(test "trailing ellipsis with empty head over a built list"
      (lambda (t)
        (define-syntax acc
          (syntax-rules ()
            ((_ () (step ... last-step))
             (list 'steps (list step ...) 'last last-step))
            ((_ (a . rest) (out ...))
             (acc rest (out ... a)))))
        (t.is (acc (10 20 30) (5)) '(steps (5 10 20) last 30))
        ;; the empty-head case: (x ... y) over a single-element built list
        (t.is (acc () (99)) '(steps () last 99))))

;; Identifiers inside `quote` are literal data, not code, so a macro must
;; transcribe them verbatim rather than hygiene-rename them. When quoted data
;; reaches the program through a side effect (set!/define) there is no return
;; value for the gensym fixup to run on, so renaming would leak `#:name`.
(test "quoted data in a macro template is not hygiene-renamed"
      (lambda (t)
        (let ((x 0))
          (define-syntax set-list
            (syntax-rules ()
              ((_) (set! x '(a b c)))))
          (set-list)
          (t.is x '(a b c)))
        ;; pattern variables inside quote are still substituted
        (define-syntax wrap
          (syntax-rules ()
            ((_ y) '(before y after))))
        (t.is (wrap middle) '(before middle after))))

;; R7RS 4.3.2 ellipsis escape: (<ellipsis> <template>) transcribes <template>
;; with `...` treated literally, but pattern variables are still substituted.
(test "ellipsis escape substitutes pattern variables"
      (lambda (t)
        (define-syntax elli-esc
          (syntax-rules ()
            ((_) '(... ...))
            ((_ x) '(... (x ...)))
            ((_ x y) '(... (... x y)))))
        (t.is (elli-esc) '...)
        (t.is (elli-esc 100) '(100 ...))
        (t.is (elli-esc 100 200) '(... 100 200))))

;; R7RS 4.3.2: a literal takes priority over the ellipsis. When the ellipsis
;; identifier is also declared as a literal it loses its special meaning and is
;; matched/transcribed as an ordinary literal.
(test "literal takes priority over the ellipsis"
      (lambda (t)
        (define-syntax elli-lit
          (syntax-rules ... (...)
            ((_ x) '(x ...))))
        (t.is (elli-lit 100) '(100 ...))
        ;; and `...` matches as a literal in the pattern
        (define-syntax elli-lit-pat
          (syntax-rules ... (...)
            ((_ ...) 'literal-ellipsis)
            ((_ x) 'variable)))
        (t.is (elli-lit-pat ...) 'literal-ellipsis)
        (t.is (elli-lit-pat 5) 'variable)))

;; A vector literal in a syntax-rules template must be transcribed back into a
;; vector (pattern variables substituted), not collapsed into an improper list.
(test "vector literal in a macro template"
      (lambda (t)
        (let-syntax ((vector-lit
                      (syntax-rules ()
                        ((vector-lit) '#(b)))))
          (t.is (vector-lit) '#(b)))
        (define-syntax vec
          (syntax-rules ()
            ((_ x) '#(x 2 3))            ;; pattern var inside quoted vector
            ((_ x y ...) #(x y ...))))   ;; non-quoted, leading fixed + ellipsis
        (t.is (vec 1) '#(1 2 3))
        (t.is (vec 0 1 2 3) '#(0 1 2 3))))

;; An ellipsis followed by fixed items and a dotted rest, `(x ... y . rest)`,
;; must match an improper (dotted) input - binding `rest` to the tail.
(test "ellipsis with fixed suffix and dotted rest matches improper list"
      (lambda (t)
        (define-syntax split
          (syntax-rules ()
            ((_ (x ... y . rest)) (list '(x ...) 'y 'rest))
            ((_ . e) 'error)))
        (t.is (split (1 2 3 4)) '((1 2 3) 4 ()))
        (t.is (split (1 2 3 4 . 9)) '((1 2 3) 4 9))
        (define-syntax part-2x
          (syntax-rules ()
            ((_ (a b (m n) ... x y . rest))
             (vector (list a b) (list m ...) (list n ...) (list x y)
                     (cons "rest:" 'rest)))
            ((_ . rest) 'error)))
        (t.is (part-2x (10 20 (31 32) (41 42) (51 52) 63 77))
              '#((10 20) (31 41 51) (32 42 52) (63 77) ("rest:")))
        (t.is (part-2x (10 20 (31 32) (41 42) (51 52) 63 77 . "tail"))
              '#((10 20) (31 41 51) (32 42 52) (63 77) ("rest:" . "tail")))))

;; An ellipsis directly followed by a dotted rest, `(x ... . rest)`, must match
;; both proper and improper lists (binding `rest` to the tail), including when
;; the ellipsis variable is used in a nested/multi-element template.
(test "ellipsis directly followed by a dotted rest"
      (lambda (t)
        (define-syntax split
          (syntax-rules ()
            ((_ (x ... . rest)) (list '(x ...) 'rest))))
        (t.is (split (1 2 3 . 9)) '((1 2 3) 9))
        (t.is (split (1 2 3)) '((1 2 3) ()))
        (define-syntax wrap-rest
          (syntax-rules ()
            ((_ (a b ... . rest)) '(a ((w b) ...) rest))))
        (t.is (wrap-rest (x p q r . z)) '(x ((w p) (w q) (w r)) z))
        (t.is (wrap-rest (x p q r)) '(x ((w p) (w q) (w r)) ()))))
