(test "core: it should set!/set-obj! with this and prototype"
      (lambda (t)
        (let ()
          (define foo (lambda (x) (set! this.x x)))
          (define bar (new foo 10))
          (set! foo.prototype.square (lambda (x) (* x x)))
          (set! foo.prototype.sum (lambda (x) (+ this.x x)))
          (t.is (bar.square 10) 100)
          (t.is (bar.sum 5) 15))
        (let ()
          (define foo (lambda (x) (set-obj! this "x" x)))
          (define bar (new foo 10))
          (set-obj! foo.prototype 'square (lambda (x) (* x x)))
          (set-obj! foo.prototype 'sum (lambda (x) (+ this.x x)))
          (t.is (bar.square 10) 100)
          (t.is (bar.sum 5) 15))))

(test "core: let/letrect/let*"
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

(test "core: it should throw on set! with undefined variable"
      (lambda (t)
        (t.is (to.throw (set! foo.bar 10)) true)
        (t.is (to.throw (set! foo 10)) true)))

(test "core: it should set object"
      (lambda (t)
        (let ((x (object :foo "jo")))
          (set! x.bar "hey")
          (t.is (string-append (--> x.bar (toUpperCase))
                               " "
                               (x.foo.toUpperCase))
                "HEY JO"))))

(test "core: it should throw when set object literal"
      (lambda (t)
        (let ((x &(:foo "jo")))
          (t.is (to.throw (set! x.foo "hey")) true)
          (t.is (to.throw (set! x.bar "hey")) true))))

(test "core: it should create object literals without values"
      (lambda (t)
        (let ((x &(:foo :bar)))
          (t.is x &(:foo #void :bar #void)))))

(test "core: it should create object with null value (#264)"
      (lambda (t)
        (let ((x &(:foo #null :bar #null)))
          (t.is (eq? x.foo #null) #t)
          (t.is (eq? x.bar #null) #t))))

(test "core: it should allow change shorthand object literals"
      (lambda (t)
        (let ((obj &(:x :y)))
          (set! obj.x 10)
          (set! obj.y 20)
          (t.is obj &(:x 10 :y 20)))
        (let ((obj &(:x :y &(:foo "bar"))))
          (set! obj.x 10)
          (t.is obj &(:x 10 :y &(:foo "bar"))))))

(test "core: it should throw when change object literals long property after short property"
      (lambda (t)
        (let ((obj &(:x :y 20)))
          (set! obj.x 10)
          (t.is (to.throw (set! obj.y 30)) true)
          (t.is obj &(:x 10 :y 20)))))


(test "core: it should throw when change nested object in shorthand object literals"
      (lambda (t)
        (let ((obj &(:x :y &(:foo "bar"))))
          (t.is (to.throw (set! obj.y.foo "baz")) true)
          (t.is obj &(:x :y &(:foo "bar"))))))

(test "core: it should throw when set vector literal"
      (lambda (t)
        (let ((x #(0 1)))
          (t.is (to.throw (set! x.0 2)) true)
          (t.is (to.throw (x.push 3)) true))))

(test "core: timing test"
      (lambda (t)
        (--> t (is (function? (.. Date.now)) true))
        (define start (--> Date (now)))
        (wait 100 (--> t (is (>= (- (--> Date (now)) start) 100) true)))))

(test "core: values"
      (lambda (t)
        (t.is (call-with-values * -) -1)
        (t.is (call-with-values (lambda () (values 4 5))
                (lambda (a b) b)) 5)
        (t.is (call-with-values (lambda () (values 4 5)) +) 9)))

(test "core: values without wrapping"
      (lambda (t)
        (t.is (values 1) 1)
        (t.is #void (values))))

(test "core: symbols"
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

(test "core: dot comma"
      (lambda (t)
        ;; found in https://doc.scheme.org/surveys/DotComma/
        (t.is  (let ((b 312)) `(a .,b)) '(a . 312))))

(test "core: quote as delimiter"
      (lambda (t)
        ;; found in https://doc.scheme.org/surveys/QuoteDelimiter/
        (t.is (list 'a'b) '(a b))))

(test "core: if"
      (lambda (t)
        (t.is (if (newline) 1 2) 1)
        (t.is (if 0 1 2) 1)
        (t.is (if #null 1 2) 2)
        (t.is (if #void 1 2) 1)
        (t.is (if () 1 2) 1)
        (t.is (if #f 1 2) 2)))

(test "core: and/or"
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

(test "core: do macro"
      (lambda (t)
        (t.is (do ((i 0) (j 10 (- j 1))) (i j)) 10)
        (t.is (do ((i 0) (j 10 (- j 1))) (#t j)) 10)
        (t.is (do ((i 0) (j 10 (- j 1))) (#void j)) 10)
        (t.is (do ((i 0) (j 10 (- j 1))) ((zero? j) 10)) 10)))

(test "core: do macro scope (#325)"
      (lambda (t)
        (t.is ((do ((f (lambda () 0)
                       (lambda () j))
                    (j 2 (- j 1)))
                 ((= j 0) f)))
              1)))

(test "core: eq?/eqv?"
      (lambda (t)
        ;; TODO
        ;;eq? bool nil symbol

        ;;eqv? number char + eq?
        (t.is true true)))

(test "core: scheme signature"
      (lambda (t)
        ;; we should know about changing of signature
        (load "@lips/examples/scheme-detect.scm")

        (t.is (detect:name) 'lips)))

(test "core: input-string-port"
      (lambda (t)

        (let ((port (open-input-string "`(```,,,,@(list 1 2)) 10 #/foo bar/")))
          (t.is (read port) '(quasiquote ((quasiquote (quasiquote (quasiquote (unquote (unquote (unquote (unquote-splicing (list 1 2)))))))))))
          (t.is (read port) 10)
          (t.is (read port) #/foo bar/)
          (t.is (eof-object? (read port)) true))))

(test "core: it should throw exception why calling with improper list"
      (lambda (t)
        (t.is (to.throw (let ((x '(1 2))) (+ 1 . x))) true)))

(test "core: it should throw exception why applying function to improper list"
      (lambda (t)
        (t.is (to.throw (let ((x '(1 2 . 3))) (apply + x))) true)))

(test "core: async for-each"
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

(test "core: access this in method"
      (lambda (t)
        (let* ((x (object :foo (lambda () this.bar) :bar 10)))
          (t.is (x.foo) 10))))

(test "core: access env in called function inside method"
      (lambda (t)
        (let* ((result (vector))
               (x (object :foo (lambda ()
                                 (for-each (lambda (x)
                                             (--> result (push x)))
                                           '(1 2 3))))))
          (x.foo)
          (t.is result #(1 2 3)))))

(test "core: access this in closure returned from method"
      (lambda (t)
        (let* ((x (object :foo (lambda ()
                         (lambda (x)
                           (+ x this.bar)))
                          :bar 1))
               (fn (x.foo)))
          (t.is (fn 2) 3))))



(test "core: quoted promise"
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

(test "core: quoted promise of object with then method"
      (lambda (t)
        (let ((p '>(object :then (lambda () 10))))
          (--> p (then (lambda (result)
                         (t.is result 10))))
          (t.is (await p) 10))))

(test "core: quoted resolved promise repr"
      (lambda (t)
        (let ((resolve))
          (define promise '>(new Promise (lambda (r) (set! resolve r))))
          (t.is (repr promise) "#<js-promise (pending)>")
          (resolve "xx")
          (t.is (await promise) "xx")
          (t.is (repr promise) "#<js-promise resolved (string)>"))))

(test "core: quoted rejected promise repr"
      (lambda (t)
        (let ((reject))
          (define promise '>(new Promise (lambda (_ r) (set! reject r))))
          (t.is (repr promise) "#<js-promise (pending)>")
          (reject (new Error "ZONK"))
          (t.is (to.throw (await promise)) true)
          (t.is (repr promise) "#<js-promise (rejected)>")
          (t.is (not (null? (promise.__reason__.message.match #/ZONK/))) true))))

(test "core: quoted promise + lexical scope"
      (lambda (t)
        (let ((x (await (let ((x 2))
                (--> '>(Promise.resolve (let ((y 4))
                                          (+ x y)))
                     (then (lambda (x)
                             (* x x))))))))
          (t.is x 36))))

(test "core: resolving promises in quoted promise realm"
      (lambda (t)
        (t.is (await (let ((x 2))
                       (--> '>(let ((y (Promise.resolve 4)))
                                (+ x y))
                            (then (lambda (x)
                                    (* x x))))))
              36)))

(test "core: promise + let"
      (lambda (t)
        (let ((x (Promise.resolve 2))
              (y (Promise.resolve 4)))
          (t.is (* x y) (Promise.resolve 8)))))

(test "core: Promise.all on quoted promises"
      (lambda (t)
        (let ((expected #(10 20))
              (result (vector '>(wait 1000 10) '>(wait 1000 20))))
          (t.is (Promise.all result) expected))))

(test "core: quoted promise in let"
      (lambda (t)

        (define (timer time value)
          (new Promise (lambda (resolve) (setTimeout (curry resolve value) time))))

        (define result (let ((x (timer 0 "hello"))
                             (y '>(timer 200 "world")))
                         (list x y)))
        (t.is (car result) "hello")
        (t.is (repr (cadr result)) "#<js-promise (pending)>")))

(test "core: delay repr"
      (lambda (t)
        (t.is (repr (delay 10)) "#<promise - not forced>")
        (define x (delay 10))
        (t.is (repr x) "#<promise - not forced>")
        (force x)
        (t.is (repr x) "#<promise - forced with number>")))

(test "core: regex"
      (lambda (t)
          (for-each (lambda (str)
                      (let ((re (. (lips.parse str) 0)))
                        (t.is (regex? re) true)
                        (t.is (repr re) str)))
                    '("#/(\\((?:env|dir|help|apropos)[^)]*\\))/g"
                      "#/u[0-9]+/")))) ;; regex for #238

(test "core: try..catch"
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

(test "core: try..catch should stop execution for-each #163"
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

(test "core: try..catch should stop execution on nesting functions #163"
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


(test "core: try..catch should stop execution base #163"
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

(test "core: chain of promises"
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

(test "core: repr of R7RS symbols"
      (lambda (t)
        (t.is (repr '|foo bar| true) "|foo bar|")
        (t.is (repr (string->symbol "foo bar") true) "|foo bar|")))

(test "core: repr of prototypes"
       (lambda (t)
         (t.is (repr lips.LNumber.prototype)
               "#<prototype>")

         (t.is (repr Number.prototype)
               "#<prototype>")

         (let ((x (object :foo (object :bar Number.prototype))))
           (t.is (repr x.foo.bar)
                 "#<prototype>"))))

(test "core: set-repr! on classes"
      (lambda (t)
        (define Foo (class Object))
        (define foo-repr "#<FOO CLASS>")
        (set-repr! Foo (lambda () foo-repr))

        (t.is (repr (new Foo)) foo-repr)))

(test "core: set-repr! on records"
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

(test "core: instance? on records"
      (lambda (t)
        (define-record-type <pare>
          (kons x y)
          pare?
          (x kar set-kar!)
          (y kdr set-kdr!))

        (t.is (instance? (kons 1 2)) #t)))

(test "core: errors and try..catch"
      (lambda (t)
        (let* ((message "Some Error")
               (args '(1 2 3))
               (err (try (apply error message args)
                         (catch (e) e))))
          (t.is (error-object? err) true)
          (t.is (error-object-message err) message)
          (t.is (error-object-irritants err) (list->vector args)))))

(test "core: should evaluate promise of code"
      (lambda (t)
        (t.is ((Promise.resolve (lambda x x)) 1 2 3) '(1 2 3))))

(test "core: should not evaluate promise of data"
      (lambda (t)
        (t.is (to.throw ((Promise.resolve 'list) 1 2 3)) true)))

(test "core: should catch quoted promise rejection"
      (lambda (t)
        (t.is (await (--> '>(Promise.reject 10)
                          (catch (lambda (e)
                                   #t))))
              #t)))

(test "core: should clone list"
      (lambda (t)
        (let* ((a '(1 2 3)) (b (clone a)))
        (t.is (not (eq? a b)) #t)
        (t.is a b))))

(test "core: should return nth element"
      (lambda (t)
        (let ((a '(1 2 3 4)))
          (t.is (nth 0 a) 1)
          (t.is (nth 1 a) 2)
          (t.is (nth 2 a) 3)
          (t.is (nth 3 a) 4))))

(test "core: escape-regex"
      (lambda (t)
        (t.is (escape-regex ".{}[]")
              "\\.\\{\\}\\[\\]")))

(test "core: env"
      (lambda (t)
        (let* ((l (env))
               (size (length l)))
          (t.is (pair? l) #t)
          (t.is (> size 100) #t)
          (let ((x 10))
            (let* ((l1 (env))
                   (l2 (env)))
              (t.is (+ (length l1) 1) (length l2)))))))

(test "core: match"
      (lambda (t)
        (t.is (match (new RegExp "(foo|bar)" "g") "foo bar")
              '("foo" "bar"))))

(test "core: search"
      (lambda (t)
        (for-each (lambda (regex)
                    (t.is (search regex "foo") 0))
                  '(#/./ #/^f/ #/foo$/))
        (t.is (search #/bar/ "foo") -1)))

(test "core: join"
      (lambda (t)
        (t.is (join ":" '("foo" "bar" "baz"))
              "foo:bar:baz")))

(test "core: replace"
      (lambda (t)
        (t.is (replace "foo" "var" "foo bar") "var bar")
        (t.is (replace (new RegExp "foo|bar" "g") "x" "foo bar") "x x")))

(test "core: split"
      (lambda (t)
        (t.is (split ":" "foo:bar:baz")
              '("foo" "bar" "baz"))
        (t.is (split #/(:)/ "foo:bar:baz")
              '("foo" ":" "bar" ":" "baz"))))

(test "core: shuffle"
      (lambda (t)
        ;; test shuffle with fixed seed
        (random 1000)
        (t.is (shuffle '(1 2 3 4)) '(2 4 3 1))
        (t.is (list? (shuffle '(1 2 3))) #t)
        (t.is (shuffle '()) '())
        (random 1000)
        (t.is (shuffle #(1 2 3 4)) #(2 4 3 1))))

(test "core: immutable strings"
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

(test "core: means"
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

(test "core: map + case"
      (lambda (t)
        (t.is (map (lambda (x)
                     (case x
                       ((a e i o u) => (lambda (w) (cons 'vowel w)))
                       ((w y) (cons 'semivowel x))
                       (else => (lambda (w) (cons 'other w)))))
                   '(z y x w u))
              '((other . z) (semivowel . y) (other . x)
                (semivowel . w) (vowel . u)))))

(test "core: and"
      (lambda (t)
        (t.is #t (and (= 2 2) (> 2 1)))
        (t.is #f (and (= 2 2) (< 2 1)))
        (t.is '(f g) (and 1 2 'c '(f g)))
        (t.is #t (and))))

(test "core: or"
      (lambda (t)
        (t.is #t (or (= 2 2) (> 2 1)))
        (t.is #t (or (= 2 2) (< 2 1)))
        (t.is #f (or #f #f #f))
        (t.is '(b c) (or (memq 'b '(a b c))
                         (/ 3 0)))))

(test "core: iterator->array"
      (lambda (t)
        (t.is (iterator->array '(1 2 3 4)) #(1 2 3 4))
        (t.is (iterator->array "hello") #(#\h #\e #\l #\l #\o))))

(test "core: async iterator->array"
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

(test "core: append!"
      (lambda (t)
        (let ((x ()))
          (set! x (append! x (list 10) () (list 20)))
          (t.is x '(10 20)))
        (let ((x '(1 2)))
          (append! x () (list 3 4) ())
          (t.is x '(1 2 3 4)))))

(test "core: number->string"
      (lambda (t)
        (t.is (number->string 0.1 16) "0.1999999999999a")
        (t.is (number->string 1.0e-27 16) "4.f3a68dbc8f04e-17")
        (t.is (number->string 1.0e+27 16) "3.3b2e3c9fd0804e+16")
        (t.is (number->string 1000000000000000000000000000 16) "33b2e3c9fd0803ce8000000")))

(test "core: replace async"
      (lambda (t)
        (t.is (replace #/foo/ (lambda () (Promise.resolve "lips")) "foo bar") "lips bar")))

(test "core: should throw proper error"
      (lambda (t)
        (t.is (try (eval '(+ x x)) (catch (e) e.message))
              "Unbound variable `x'")))

(test "core: quoted list mutation"
      (lambda (t)
        (let ((list '(1 2 3 4)))
          (set-car! list 10)
          (t.is list '(10 2 3 4)))))

(test "core: freeze list"
      (lambda (t)
        (let ((lst '(1 2 3 4)))
          (lst.freeze)
          (let loop ((lst lst))
            (when (not (null? lst))
              (let ((item (car lst)))
                (t.is (vector item (to.throw (set-car! lst 10)))
                      (vector item true)))
              (loop (cdr lst)))))))

(test "core: floor/quotient on big int rational"
      (lambda (t)
        (let ((result 1002003004005006007008009010011012013014015016017018019020021022023024025026027028029030031032033034035036037038039040041042043044045046047048049050051052053054055056057058059060061062063064065066067068069070071072073074075076077078079080081082083084085086087088089090091092093094095096097098099100101102103104105106107108109110111112113114115116117118119120121122123124125126127128129130131132133134135136137138139140141142143144145146147148149150151152153154155156157158159160161162163164165166167168169170171172173174175176177178179180181182183184185186187188189190191192193194195196197198199200201202203204205206207208209210211212213214215216217218219220221222223224225226227228229230231232233234235236237238239240241242243244245246247248249250251252253254255256257258259260261262263264265266267268269270271272273274275276277278279280281282283284285286287288289290291292293294295296297298299300301302303304305306307308309310311312313314315316317318319320321322323324325326327328329330331332333334335336337338339340341342343344345346347348349350351352353354355356357358359360361362363364365366367368369370371372373374375376377378379380381382383384385386387388389390391392393394395396397398399400401402403404405406407408409410411412413414415416417418419420421422423424425426427428429430431432433434435436437438439440441442443444445446447448449450451452453454455456457458459460461462463464465466467468469470471472473474475476477478479480481482483484485486487488489490491492493494495496497498499500501502503504505506507508509510511512513514515516517518519520521522523524525526527528529530531532533534535536537538539540541542543544545546547548549550551552553554555556557558559560561562563564565566567568569570571572573574575576577578579580581582583584585586587588589590591592593594595596597598599600601602603604605606607608609610611612613614615616617618619620621622623624625626627628629630631632633634635636637638639640641642643644645646647648649650651652653654655656657658659660661662663664665666667668669670671672673674675676677678679680681682683684685686687688689690691692693694695696697698699700701702703704705706707708709710711712713714715716717718719720721722723724725726727728729730731732733734735736737738739740741742743744745746747748749750751752753754755756757758759760761762763764765766767768769770771772773774775776777778779780781782783784785786787788789790791792793794795796797798799800801802803804805806807808809810811812813814815816817818819820821822823824825826827828829830831832833834835836837838839840841842843844845846847848849850851852853854855856857858859860861862863864865866867868869870871872873874875876877878879880881882883884885886887888889890891892893894895896897898899900901902903904905906907908909910911912913914915916917918919920921922923924925926927928929930931932933934935936937938939940941942943944945946947948949950951952953954955956957958959960961962963964965966967968969970971972973974975976977978979980981982983984985986987988989990991992993994995996997999))
          (t.is (floor (/ (expt 1000 999) 998001)) result)
          (t.is (quotient (expt 1000 999) 998001) result))))

;; TODO
;; begin*
;; set-obj! throws with null or boolean
;; set-obj! to delete the value (2 arguments)
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
