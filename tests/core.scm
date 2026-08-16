(trace #t)

(define core/stack (let ((x 10))
                     (let ((y 20))
                       (stack-trace (call/cc (lambda (cc) cc))))))
(trace #f)

(test "trace"
      (lambda (t)
        (t.is core/stack
              "[0]: (define core/stack (let ((x 10)) (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc))))))
               [1]: (let ((x 10)) (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc)))))
               [2]: (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc))))
               [3]: (stack-trace (call/cc (lambda (cc) cc)))
               [4]: (call/cc (lambda (cc) cc))
               [5]: (lambda (cc) cc)")))

(test "it should set!/set-object! with this and prototype"
      (lambda (t)
        (let ()
          (define foo (lambda (x) (set! this.x x)))
          (define bar (new foo 10))
          (set! foo.prototype.square (lambda (x) (* x x)))
          (set! foo.prototype.sum (lambda (x) (+ this.x x)))
          (t.is (bar.square 10) 100)
          (t.is (bar.sum 5) 15))
        (let ()
          (define foo (lambda (x) (set-object! this "x" x)))
          (define bar (new foo 10))
          (set-object! foo.prototype 'square (lambda (x) (* x x)))
          (set-object! foo.prototype 'sum (lambda (x) (+ this.x x)))
          (t.is (bar.square 10) 100)
          (t.is (bar.sum 5) 15))))

(test "implicit begin in lambda body is hygienic"
      (lambda (t)
        ;; a multi-expression lambda body is wrapped in an implicit `begin`.
        ;; that wrapper is cached per-lambda and must not be affected by the
        ;; user rebinding `begin` in scope.
        (let ()
          (define begin 42)
          (define (f x)
            (define y (* x 2))
            (+ x y))
          (t.is begin 42)
          (t.is (f 10) 30))
        ;; distinct closures created from the same lambda expression keep
        ;; independent cached bodies
        (let ()
          (define (make k)
            (lambda (x)
              (define t (+ x k))
              t))
          (define g1 (make 100))
          (define g2 (make 200))
          (t.is (list (g1 1) (g2 1) (g1 2) (g2 2))
                (list 101 201 102 202)))))

(test "help returns docs for the requested symbol"
      (lambda (t)
        ;; (help <name>) must return the documentation of <name>, never of
        ;; `help` itself. Regression: a help wrapper that forwarded the whole
        ;; `(help x)` form (instead of the argument list) made every query
        ;; resolve `help`, so (help lambda) returned help's own documentation.
        (t.is (string=? (help car)
                        "(car pair)

This function returns the car (item 1) of the list.")
              #t)
        (t.is (string=? (substring (help lambda) 0 19) "(lambda (a b) body)")
              #t)
        ;; the doc of a queried symbol must differ from help's own doc - proves
        ;; we didn't fall back to documenting `help`
        (t.is (string=? (help lambda) (help help)) #f)))

(test "help resolves docstrings stored in __docs__ at runtime"
      (lambda (t)
        ;; a user function's docstring lives in the environment's __docs__ map
        ;; (created lazily); help must read it back at runtime
        (define (documented-fn x)
          "documented-fn squares its argument"
          (* x x))
        (t.is (string=? (help documented-fn) "documented-fn squares its argument")
              #t)))

(test "let/letrect/let*"
      (lambda (t)
        ;; tests based on book Sketchy Scheme by Nils M Holm
        (t.is (to.throw (let ((down (lambda (x)
                                      (if (zero? x)
                                          0
                                          (down (- x 1))))))
                          (down 5)))
              true)

         (t.is (letrec ((down (lambda (x)
                                (if (zero? x)
                                    0
                                    (down (- x 1))))))
                 (down 5))
               0)

         (let ((a '(outer-a))
               (b '(outer-b)))
           (let ((a '(0))
                 (b (cons 1 a))
                 (c (cons 2 b)))
             (t.is c '(2 outer-b))))

         (let ((a '(outer-a))
               (b '(outer-b)))
           (let* ((a '(0))
                  (b (cons 1 a))
                  (c (cons 2 b)))
             (t.is c '(2 1 0))))

         (t.is (letrec ((a 10)
                        (b 20))
                 (+ a b))
               30)

         (t.is (letrec ((a 10)
                        (b a))
                  (+ a b))
               20)

         (t.is (to.throw (let ((a 10)
                               (b a))
                           (+ a b)))
               true)))

(test "it should throw on set! with undefined variable"
      (lambda (t)
        (t.is (to.throw (set! foo.bar 10)) true)
        (t.is (to.throw (set! foo 10)) true)))

(test "it should set object"
      (lambda (t)
        (let ((x (object :foo "jo")))
          (set! x.bar "hey")
          (t.is (string-append (--> x.bar (toUpperCase))
                               " "
                               (x.foo.toUpperCase))
                "HEY JO"))))

(test "it should throw when set object literal"
      (lambda (t)
        (let ((x &(:foo "jo")))
          (t.is (to.throw (set! x.foo "hey")) true)
          (t.is (to.throw (set! x.bar "hey")) true))))

(test "it should create object literals without values"
      (lambda (t)
        (let ((x &(:foo :bar)))
          (t.is x &(:foo #void :bar #void)))))

(test "it should create object with null value (#264)"
      (lambda (t)
        (let ((x &(:foo #null :bar #null)))
          (t.is (eq? x.foo #null) #t)
          (t.is (eq? x.bar #null) #t))))

(test "it should allow change shorthand object literals"
      (lambda (t)
        (let ((obj &(:x :y)))
          (set! obj.x 10)
          (set! obj.y 20)
          (t.is obj &(:x 10 :y 20)))
        (let ((obj &(:x :y &(:foo "bar"))))
          (set! obj.x 10)
          (t.is obj &(:x 10 :y &(:foo "bar"))))))

(test "it should throw when change object literals long property after short property"
      (lambda (t)
        (let ((obj &(:x :y 20)))
          (set! obj.x 10)
          (t.is (to.throw (set! obj.y 30)) true)
          (t.is obj &(:x 10 :y 20)))))


(test "it should throw when change nested object in shorthand object literals"
      (lambda (t)
        (let ((obj &(:x :y &(:foo "bar"))))
          (t.is (to.throw (set! obj.y.foo "baz")) true)
          (t.is obj &(:x :y &(:foo "bar"))))))

(test "it should throw when set vector literal"
      (lambda (t)
        (let ((x #(0 1)))
          (t.is (to.throw (set! x.0 2)) true)
          (t.is (to.throw (x.push 3)) true))))

(test "timing test"
      (lambda (t)
        (--> t (is (function? Date.now) true))
        (define start (--> Date (now)))
        (wait 100 (--> t (is (>= (- (Date.now) start) 100) true)))))

(test "values"
      (lambda (t)
        (t.is (call-with-values * -) -1)
        (t.is (call-with-values (lambda () (values 4 5))
                (lambda (a b) b)) 5)
        (t.is (call-with-values (lambda () (values 4 5)) +) 9)))

(test "values without wrapping"
      (lambda (t)
        (t.is (values 1) 1)
        (t.is #void (values))))

(test "symbols"
      (lambda (t)
        (t.is '|foo\x20;bar| (string->symbol "foo bar"))
        (t.is '|\n| (string->symbol "\n"))
        (t.is '|\t\t| (string->symbol "\t\t"))
        (t.is '|\r| (string->symbol "\r"))
        (t.is '|\s| '\s)
        (t.is '|\x3BB;| 'λ)
        (t.is '|\x9;\x9;| '|\t\t|)
        ;; found in
        ;; https://docs.scheme.org/surveys/reader-vertical-bar-concatenated-with-number/
        (t.is (lips.tokenize "|1|aaa |a|b|c| |foo bar|")
              #("|1|aaa" "|a|b|c|" "|foo bar|"))))

(test "dot comma"
      (lambda (t)
        ;; found in https://doc.scheme.org/surveys/DotComma/
        (t.is (let ((b 312)) `(a .,b)) '(a . 312))))

(test "quote as delimiter"
      (lambda (t)
        ;; found in https://doc.scheme.org/surveys/QuoteDelimiter/
        (t.is (list 'a'b) '(a b))))

(test "if"
      (lambda (t)
        (t.is (if (newline) 1 2) 1)
        (t.is (if 0 1 2) 1)
        (t.is (if #null 1 2) 2)
        (t.is (if #void 1 2) 1)
        (t.is (if () 1 2) 1)
        (t.is (if #f 1 2) 2)))

(test "and/or"
      (lambda (t)
        (t.is (and) #t)
        (t.is (or) #f)
        ;; #void should be true values
        ;; according to spec #f should be the only false value
        ;; but Kawa use #!null constants that is also false
        (t.is (and 1 #void) #void)
        (t.is (and 1 #null) #null)
        (t.is (or (begin) 1) #void)
        (t.is (or #null 1) 1)))

(test "do macro"
      (lambda (t)
        (t.is (do ((i 0) (j 10 (- j 1))) (i j)) 10)
        (t.is (do ((i 0) (j 10 (- j 1))) (#t j)) 10)
        (t.is (do ((i 0) (j 10 (- j 1))) (#void j)) 10)
        (t.is (do ((i 0) (j 10 (- j 1))) ((zero? j) 10)) 10)))

(test "do macro scope (#325)"
      (lambda (t)
        (t.is ((do ((f (lambda () 0)
                       (lambda () j))
                    (j 2 (- j 1)))
                 ((= j 0) f)))
              1)))

(test "eq?/eqv?"
      (lambda (t)
        ;; TODO
        ;;eq? bool nil symbol

        ;;eqv? number char + eq?
        (t.is true true)))

(test "scheme signature"
      (lambda (t)
        ;; we should know about changing of signature
        (load "@lips/examples/scheme-detect.scm")

        (t.is (detect:name) 'lips)))

(test "input-string-port"
      (lambda (t)

        (let ((port (open-input-string "`(```,,,,@(list 1 2)) 10 #/foo bar/")))
          (t.is (read port) '(quasiquote ((quasiquote (quasiquote (quasiquote (unquote (unquote (unquote (unquote-splicing (list 1 2)))))))))))
          (t.is (read port) 10)
          (t.is (read port) #/foo bar/)
          (t.is (eof-object? (read port)) true))))

(test "it should throw exception why calling with improper list"
      (lambda (t)
        (t.is (to.throw (let ((x '(1 2))) (+ 1 . x))) true)))

(test "it should throw exception why applying function to improper list"
      (lambda (t)
        (t.is (to.throw (let ((x '(1 2 . 3))) (apply + x))) true)))

(test "async for-each"
      (lambda (t)
          (define (delay x)
            (new Promise (lambda (r)
                           (setTimeout r x))))
          (let* ((result (vector))
                 (push (lambda (x) (--> result (push x))))
                 (count 4)
                 (time 100)
                 (numbers (map (curry + 1) (range count)))
                 (start (Date.now)))
            (push 0)
            (for-each (lambda (x)
                        (delay time)
                        (--> result (push x)))
                      numbers)
            (push (+ 1 count))
            (let ((end (Date.now)))
              (t.is (>= (- end start) (* (+ count 1) time)) true))
            (t.is result (--> #(0) (concat (list->vector numbers) (vector (+ count 1))))))))

(test "access this in method"
      (lambda (t)
        (let* ((x (object :foo (lambda () this.bar) :bar 10)))
          (t.is (x.foo) 10))))

(test "access env in called function inside method"
      (lambda (t)
        (let* ((result (vector))
               (x (object :foo (lambda ()
                                 (for-each (lambda (x)
                                             (--> result (push x)))
                                           '(1 2 3))))))
          (x.foo)
          (t.is result #(1 2 3)))))

(test "access this in closure returned from method"
      (lambda (t)
        (let* ((x (object :foo (lambda ()
                         (lambda (x)
                           (+ x this.bar)))
                          :bar 1))
               (fn (x.foo)))
          (t.is (fn 2) 3))))



(test "quoted promise"
      (lambda (t)
        (let ((result (vector))
              (p '>(new Promise (lambda (resolve)
                                  (setTimeout (lambda ()
                                                (resolve 10))
                                              100)))))
          (p.then (lambda (x)
                    (result.push x)))
          (t.is result #())
          (await p)
          (t.is result #(10)))))

(test "quoted promise of object with then method"
      (lambda (t)
        (let ((p '>(object :then (lambda (fn)
                                   (fn 10)
                                   this))))
          (--> p (then (lambda (result)
                         (t.is result 10))))
          (t.is (await p) 10))))

(test "quoted resolved promise repr"
      (lambda (t)
        (let ((resolve))
          (define promise '>(new Promise (lambda (r) (set! resolve r))))
          (t.is (repr promise) "#<js-promise (pending)>")
          (resolve "xx")
          (t.is (await promise) "xx")
          (t.is (repr promise) "#<js-promise resolved (string)>"))))

(test "quoted rejected promise repr"
      (lambda (t)
        (let ((reject))
          (define promise '>(new Promise (lambda (_ r) (set! reject r))))
          (t.is (repr promise) "#<js-promise (pending)>")
          (reject (new Error "ZONK"))
          (t.is (to.throw (await promise)) true)
          (t.is (repr promise) "#<js-promise (rejected)>")
          (t.is (not (null? (promise.__reason__.message.match #/ZONK/))) true))))

(test "quoted promise + lexical scope"
      (lambda (t)
        (let ((x (await (let ((x 2))
                (--> '>(Promise.resolve (let ((y 4))
                                          (+ x y)))
                     (then (lambda (x)
                             (* x x))))))))
          (t.is x 36))))

(test "resolving promises in quoted promise realm"
      (lambda (t)
        (t.is (await (let ((x 2))
                       (--> '>(let ((y (Promise.resolve 4)))
                                (+ x y))
                            (then (lambda (x)
                                    (* x x))))))
              36)))

(test "promise + let"
      (lambda (t)
        (let ((x (Promise.resolve 2))
              (y (Promise.resolve 4)))
          (t.is (* x y) (Promise.resolve 8)))))

(test "Promise.all on quoted promises"
      (lambda (t)
        (let ((expected #(10 20))
              (result (vector '>(wait 1000 10) '>(wait 1000 20))))
          (t.is (Promise.all result) expected))))

(test "quoted promise in let"
      (lambda (t)

        (define (timer time value)
          (new Promise (lambda (resolve) (setTimeout (curry resolve value) time))))

        (define result (let ((x (timer 0 "hello"))
                             (y '>(timer 200 "world")))
                         (list x y)))
        (t.is (car result) "hello")
        (t.is (repr (cadr result)) "#<js-promise (pending)>")))

(test "delay repr"
      (lambda (t)
        (t.is (repr (delay 10)) "#<promise - not forced>")
        (define x (delay 10))
        (t.is (repr x) "#<promise - not forced>")
        (force x)
        (t.is (repr x) "#<promise - forced with number>")))

(test "regex"
      (lambda (t)
          (for-each (lambda (str)
                      (let ((re (. (lips.parse str) 0)))
                        (t.is (regex? re) true)
                        (t.is (repr re) str)))
                    '("#/(\\((?:env|dir|help|apropos)[^)]*\\))/g"
                      "#/u[0-9]+/")))) ;; regex for #238

(test "try..catch"
      (lambda (t)
        (begin
         (let ((x))
           (t.is (try 10 (finally (set! x 10))) 10)
           (t.is x 10))

         (let ((x))
           (t.is (try aa (catch (e) false) (finally (set! x 10))) false)
           (t.is x 10))

         (let ((x 10))
           (t.is (to.throw (try 10 (finally (throw "error") (set! x 20)))) true)
           (t.is x 10))

         (t.is (to.throw (try bb (catch (e) (throw e)))) true)

         (let ((x))
           (t.is (to.throw (try cc (finally (set! x 10)))) true)
           (t.is x 10))

         (let ((x))
           (t.is (try (new Promise (lambda (r) (r 10))) (finally (set! x 10))) 10)
           (t.is x 10))

         (let ((x))
           (t.is (to.throw (try (Promise.reject 10) (catch (e) (set! x 10) (throw e)))) true)
           (t.is x 10))

         (t.is (try xx (catch (e) false)) false)

         (let ((x))
           (t.is (try (Promise.reject 10) (catch (e) e) (finally (set! x 10))) 10)
           (t.is x 10))

         (t.is (try (Promise.reject 10) (catch (e) e)) 10)

         (t.is (to.throw (try (Promise.reject 10) (catch (e) (throw e)))) true)

         (let ((x))
           (t.is (to.throw (try (Promise.reject 10) (finally (set! x 10)))) true)
           (t.is x 10)))))

(test "try..catch should stop execution for-each #163"
      (lambda (t)
        (define (until-zero fn lst)
          (let ((result (vector)))
            (try (for-each (lambda (x)
                             (if (zero? x)
                                 (throw 'ZONK)
                                 (result.push (fn x))))
                           lst)
                 (catch (e)
                        result))))

        (t.is (until-zero identity '(1 2 3 4 0 10 20 30)) #(1 2 3 4))
        (t.is (until-zero identity '(0 1 2 3 4)) #())))

(test "try..catch should stop execution on nesting functions #163"
      (lambda (t)
        (t.plan 1)
        (let ((result (vector)))
          (define (foo fn lst)
            (for-each (lambda (x)
                        (if (zero? x)
                            (throw 'ZONK)
                            (fn x)))
                      lst))

          (define (bar)
            (foo (lambda (item)
                   (result.push item))
                 '(-1 1 0 2 3 4)))

          (t.is (try
                 (bar)
                 (catch (e)
                        result))
                #(-1 1)))))


(test "try..catch should stop execution base #163"
      (lambda (t)
        (let ((result #f))
          (try
           (begin
             (set! result 1)
             (throw 'ZONK)
             (set! result 2))
           (catch (e)
                  (set! result 3)))
          (t.is result 3))))

(test "chain of promises"
      (lambda (t)
        (define-macro (delay time . expr)
          (let ((resolve (gensym "resolve")))
            `(new Promise (lambda (,resolve)
                            (setTimeout (lambda ()
                                          (,resolve (begin ,@expr)))
                                        ,time)))))

        (let ((x 1) (y 2))
          (delay 100 (set! x 10))
          (delay 100 (set! y 20))
          (t.is (+ x y) 30))

        ;; bug #116
        (let ((x 1))
          (t.is (list (delay 200 (set! x 10) 10)
                      (delay 100 x))
                '(10 10)))

        (let ((x 1))
          (t.is (list* (delay 200 (set! x 10) 10)
                       (delay 100 x))
                '(10 1)))))

(test "repr of R7RS symbols"
      (lambda (t)
        (t.is (repr '|foo bar| true) "|foo bar|")
        (t.is (repr (string->symbol "foo bar") true) "|foo bar|")))

(test "repr of prototypes"
       (lambda (t)
         (t.is (repr lips.LNumber.prototype)
               "#<prototype>")

         (t.is (repr Number.prototype)
               "#<prototype>")

         (let ((x (object :foo (object :bar Number.prototype))))
           (t.is (repr x.foo.bar)
                 "#<prototype>"))))

(test "set-repr! on classes"
      (lambda (t)
        (define Foo (class Object))
        (define foo-repr "#<FOO CLASS>")
        (set-repr! Foo (lambda () foo-repr))

        (t.is (repr (new Foo)) foo-repr)))

(test "set-repr! on records"
      (lambda (t)
        (define-record-type <pare>
          (kons x y)
          pare?
          (x kar set-kar!)
          (y kdr set-kdr!))

        (set-repr! <pare>
                   (lambda (x q)
                     (string-append "(" (repr (kar x) q)
                                    " . "
                                    (repr (kdr x) q)
                                    ")")))

        (t.is (repr (kons 1 2)) "(1 . 2)")))

(test "instance? on records"
      (lambda (t)
        (define-record-type <pare>
          (kons x y)
          pare?
          (x kar set-kar!)
          (y kdr set-kdr!))

        (t.is (instance? (kons 1 2)) #t)))

(test "errors and try..catch"
      (lambda (t)
        (let* ((message "Some Error")
               (args '(1 2 3))
               (err (try (apply error message args)
                         (catch (e) e))))
          (t.is (error-object? err) true)
          (t.is (error-object-message err) message)
          (t.is (error-object-irritants err) (list->vector args)))))

(test "should evaluate promise of code"
      (lambda (t)
        (t.is ((Promise.resolve (lambda x x)) 1 2 3) '(1 2 3))))

(test "should not evaluate promise of data"
      (lambda (t)
        (t.is (to.throw ((Promise.resolve 'list) 1 2 3)) true)))

(test "should catch quoted promise rejection"
      (lambda (t)
        (t.is (await (--> '>(Promise.reject 10)
                          (catch (lambda (e)
                                   #t))))
              #t)))

(test "should clone list"
      (lambda (t)
        (let* ((a '(1 2 3)) (b (clone a)))
        (t.is (not (eq? a b)) #t)
        (t.is a b))))

(test "should return nth element"
      (lambda (t)
        (let ((a '(1 2 3 4)))
          (t.is (nth 0 a) 1)
          (t.is (nth 1 a) 2)
          (t.is (nth 2 a) 3)
          (t.is (nth 3 a) 4))))

(test "escape-regex"
      (lambda (t)
        (t.is (escape-regex ".{}[]")
              "\\.\\{\\}\\[\\]")))

(test "env"
      (lambda (t)
        (let* ((l (env))
               (size (length l)))
          (t.is (pair? l) #t)
          (t.is (> size 100) #t)
          (let ((x 10))
            (let* ((l1 (env))
                   (l2 (env)))
              (t.is (+ (length l1) 1) (length l2)))))))

(test "match"
      (lambda (t)
        (t.is (match (new RegExp "(foo|bar)" "g") "foo bar")
              '("foo" "bar"))))

(test "search"
      (lambda (t)
        (for-each (lambda (regex)
                    (t.is (search regex "foo") 0))
                  '(#/./ #/^f/ #/foo$/))
        (t.is (search #/bar/ "foo") -1)))

(test "join"
      (lambda (t)
        (t.is (join ":" '("foo" "bar" "baz"))
              "foo:bar:baz")))

(test "replace"
      (lambda (t)
        (t.is (replace "foo" "var" "foo bar") "var bar")
        (t.is (replace (new RegExp "foo|bar" "g") "x" "foo bar") "x x")))

(test "split"
      (lambda (t)
        (t.is (split ":" "foo:bar:baz")
              '("foo" "bar" "baz"))
        (t.is (split #/(:)/ "foo:bar:baz")
              '("foo" ":" "bar" ":" "baz"))))

(test "shuffle"
      (lambda (t)
        ;; test shuffle with fixed seed
        (random 1000)
        (t.is (shuffle '(1 2 3 4)) '(4 2 3 1))
        (t.is (list? (shuffle '(1 2 3))) #t)
        (t.is (shuffle '()) '())
        (random 1000)
        (t.is (shuffle #(1 2 3 4)) #(4 2 3 1))))

(test "immutable strings"
      (lambda (t)
        (t.is (to.throw
               (let* ((x "hello")
                      (f (lambda () x)))
                 (string-set! (f) 0 #\x)))
              true)
        (t.is (to.throw
               (let* ((x (string-symbol 'immutable))
                      (f (lambda () x)))
                 (string-set! (f) 0 #\x)))
              true)))

(test "means"
      (lambda (t)
        ;; By Jussi Piitulainen <jpiitula@ling.helsinki.fi>
        ;; and John Cowan <cowan@mercury.ccil.org>:
        ;; http://lists.scheme-reports.org/pipermail/scheme-reports/2013-December/003876.html
        (define (means ton)
          (letrec*
              ((mean
                (lambda (f g)
                  (f (/ (sum g ton) n))))
               (sum
                (lambda (g ton)
                  (if (null? ton)
                      (+)
                      (if (number? ton)
                          (g ton)
                          (+ (sum g (car ton))
                             (sum g (cdr ton)))))))
               (n (sum (lambda (x) 1) ton)))
            (values (mean values values)
                    (mean exp log)
                    (mean / /))))

        (let*-values (((a b c) (means '(8 5 99 1 22))))
          (t.is 27 a)
          (t.is 9.728000255822641 b)
          (t.is 1800/497 c))))

(test "map + case"
      (lambda (t)
        (t.is (map (lambda (x)
                     (case x
                       ((a e i o u) => (lambda (w) (cons 'vowel w)))
                       ((w y) (cons 'semivowel x))
                       (else => (lambda (w) (cons 'other w)))))
                   '(z y x w u))
              '((other . z) (semivowel . y) (other . x)
                (semivowel . w) (vowel . u)))))

(test "and"
      (lambda (t)
        (t.is #t (and (= 2 2) (> 2 1)))
        (t.is #f (and (= 2 2) (< 2 1)))
        (t.is '(f g) (and 1 2 'c '(f g)))
        (t.is #t (and))))

(test "or"
      (lambda (t)
        (t.is #t (or (= 2 2) (> 2 1)))
        (t.is #t (or (= 2 2) (< 2 1)))
        (t.is #f (or #f #f #f))
        (t.is '(b c) (or (memq 'b '(a b c))
                         (/ 3 0)))))

(test "iterator->array"
      (lambda (t)
        (t.is (iterator->array '(1 2 3 4)) #(1 2 3 4))
        (t.is (iterator->array "hello") #(#\h #\e #\l #\l #\o))))

(test "async iterator->array"
      (lambda (t)
        (define gen (self.eval "
          (async function* gen(time, ...args) {
              function delay(time) {
                  return new Promise((resolve) => {
                      setTimeout(resolve, time);
                  });
              }
              for (let x of args) {
                  await delay(time);
                  yield x;
              }
          })"))

        (t.is (iterator->array (gen 100 1 2 3 4 5))
              #(1 2 3 4 5))))

(test "append!"
      (lambda (t)
        (let ((x ()))
          (set! x (append! x (list 10) () (list 20)))
          (t.is x '(10 20)))
        (let ((x '(1 2)))
          (append! x () (list 3 4) ())
          (t.is x '(1 2 3 4)))))

(test "number->string"
      (lambda (t)
        (t.is (number->string 0.1 16) "0.1999999999999a")
        (t.is (number->string 1.0e-27 16) "4.f3a68dbc8f04e-17")
        (t.is (number->string 1.0e+27 16) "3.3b2e3c9fd0804e+16")
        (t.is (number->string 1000000000000000000000000000 16) "33b2e3c9fd0803ce8000000")))

(test "replace async"
      (lambda (t)
        (t.is (replace #/foo/ (lambda () (Promise.resolve "lips")) "foo bar") "lips bar")))

(test "should throw proper error"
      (lambda (t)
        (t.is (try (eval '(+ x x)) (catch (e) e.message))
              "Unbound variable `x'")))

(test "auto bind/unbind"
      (lambda (t)
        (define obj (let ((o (Object)))
                      (set-object! o "value" 42)
                      (set-object! o "getValue" (lambda () this.value))
                      o))
        (t.is (obj.getValue) 42)              ; direct: method auto-bound to obj

        (define getter obj.getValue)
        (t.is (getter) 42)                    ; survives being stored in a var

        (define (fetch o) o.getValue)
        (t.is ((fetch obj)) 42)               ; survives being a function RESULT

        (define arr (vector 3 1 2))
        (define joiner arr.join)
        (t.is (joiner "-") "3-1-2")           ; native this-dependent method

        (define sorter arr.sort)
        (sorter (lambda (a b) (- a b)))       ; LIPS lambda crossing into native
        (t.is arr #(1 2 3))
        (t.is (arr.map (lambda (x) (* x x))) #(1 4 9))

        (t.is (eq? arr.push.valueOf Function.prototype.valueOf) #t)))  ; auto-unbind

(test "bind/unbind"
      (lambda (t)
        (define arr (vector 1 2 3))
        (define push arr.push)

        (push 4)
        (t.is arr #(1 2 3 4))

        (t.is (eq? (unbind push) Array.prototype.push) #t)

        (t.is (eq? (push.valueOf) (unbind push)) #t)

        (define other (vector))
        (t.is (eq? (unbind arr.push) (unbind other.push)) #t)

        (t.is (eq? push (unbind push)) #t)

        (define plain (lambda (x) (* x x)))
        (t.is (eq? (unbind plain) plain) #t)
        (t.is (eq? (unbind (unbind push)) (unbind push)) #t)

        (define raw (unbind push))
        (define hard (raw.bind arr))
        (t.is (eq? (unbind hard) raw) #f)   ; unbind can't undo a hard bind
        (t.is (eq? hard raw) #f)))          ; and it is opaque to eq?

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

(test "parameterize dynamic scope through a procedure"
      (lambda (t)
        (define p (make-parameter 10))
        (define (get) (p))
        (t.is (get) 10)
        (t.is (parameterize ((p 20)) (get)) 20)
        (t.is (get) 10)))

(test "parameterize nested"
      (lambda (t)
        (define p (make-parameter 0))
        (t.is (parameterize ((p 1))
                (parameterize ((p 2))
                  (p)))
              2)
        (t.is (p) 0)))

;; the following are based on
;; https://docs.racket-lang.org/guide/parameterize.html

(test "parameterize deeply nested restores outer value"
      (lambda (t)
        (define location (make-parameter "here"))
        (t.is (location) "here")
        (t.is (parameterize ((location "there")) (location)) "there")
        (t.is (parameterize ((location "in a house"))
                (list (location)
                      (parameterize ((location "with a mouse"))
                        (location))
                      (location)))
              '("in a house" "with a mouse" "in a house"))))

(test "parameter closure does not capture dynamic binding"
      (lambda (t)
        ;; a procedure created inside parameterize reads the CURRENT dynamic
        ;; value when called, not the one in effect when it was created
        (define location (make-parameter "here"))
        (define get
          (parameterize ((location "with a fox"))
            (lambda () (location))))
        (t.is (get) "here")))

(test "parameter setter changes value"
      (lambda (t)
        ;; calling a parameter with an argument mutates its value
        (define location (make-parameter "here"))
        (t.is (list (location)
                    (begin (location "there")
                           (location)))
              '("here" "there"))))

(test "parameter setter inside parameterize"
      (lambda (t)
        (define location (make-parameter "here"))
        (define (try-again! where) (location where))
        (t.is (parameterize ((location "on a train"))
                (list (location)
                      (begin (try-again! "in a boat")
                             (location))))
              '("on a train" "in a boat"))))

(test "parameterize with force/delay"
      (lambda (t)
        ;; example taken from SRFI-155: the promise captures the value at
        ;; creation time, so forcing it under parameterize still sees 1
        (t.is (let ()
                (define x (make-parameter 1))
                (define p (delay (x)))
                (define (g p) (parameterize ((x 2)) (force p)))
                (+ (force p) (g p)))
              2)))
(test "quoted list mutation"
      (lambda (t)
        (let ((list '(1 2 3 4)))
          (set-car! list 10)
          (t.is list '(10 2 3 4)))))

(test "freeze list"
      (lambda (t)
        (let ((lst '(1 2 3 4)))
          (lst.freeze)
          (let loop ((lst lst))
            (when (not (null? lst))
              (let ((item (car lst)))
                (t.is (vector item (to.throw (set-car! lst 10)))
                      (vector item true)))
              (loop (cdr lst)))))))

(test "runtime error augmentation"
      (lambda (t)
        (trace #t)
        (let ((file "./tests/files/runtime-error.scm"))
          (let ((e (to.throw.error (load file))))
            (t.snapshot (Object.getOwnPropertyNames e))))
        (trace #f)))

(test "promise rejection augmentation"
      (lambda (t)
        (trace #t)
        (let ((file "./tests/files/runtime-promise-reject.scm"))
          (let ((e (to.throw.error (load file))))
            (t.snapshot (Object.getOwnPropertyNames e))))
        (trace #f)))

(test "symbol meta tags in input string port"
      (lambda (t)
        (trace #t)
        (let ((port (open-input-string "(one two three)")))
          (t.is (map (lambda (symbol) symbol.__col__) (read port))
                '(1 5 9)))
        (trace #f)))

(test "error augumentation in try..catch at parse time"
      (lambda (t)
        #!trace
        (let ((message (try (throw (new Error "Nasty")) (catch (e) e.message))))
          #!no-trace
          (t.is (list? (match #/Nasty at line [0-9]+ and column [0-9]+/g message)) #t))))

(test "Promise rejection augumentation in try..catch at parse time"
      (lambda (t)
        #!trace
        (let ((message (try (Promise.reject (new Error "Nasty")) (catch (e) e.message))))
          #!no-trace
          (t.is (list? (match #/Nasty at line [0-9]+ and column [0-9]+/g message)) #t))))


;; TODO
;; begin*
;; set-object! throws with null or boolean
;; set-object! to delete the value (2 arguments)
;; null-environment
;; current-environment inside let
;; eval that throw error
;; syntax-rules: throws identifier non symbol
;; evaluate: number, invoke string, env === true
;; map with native function (map parseInt '("10" "20" "30"))
;; type on iterator and async iterator and (type (self.eval "new function() {}"))
;; toString/repr: jQuery, function, global, null, (Object.create null), LNumber
;;                define-class with toString method
;;                set-repr! with non function
;;                new: JavaScript class, lambda with name
;;                iterator as object literal and class
;;                async iterator as object literal and class
;;                parseInt, define-class function with name and without
;;                javascript, custom function with name and without
;;                std function and anonymous lambda
;;                function with toString
;;                user repr
;; Pair::flatten
;; Test Parser Errors "(foo" "(foo))" "(foo) ("
