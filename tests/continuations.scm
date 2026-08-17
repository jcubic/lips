(define cc/counter '())
(define cc/result/1 '())

(define (make-counter n)
  (let ((m (call/cc
            (lambda (cont)
              (begin
                (set! cc/counter cont)
                0)))))
    (begin
      (set! n (+ n 1))
      (+ m n))))

(set! cc/result/1 (cons (make-counter 0) cc/result/1))
(cc/counter 0)
(cc/counter 0)

(define (make-iterator lst)

  (define state
    (lambda (return)
      (for-each
       (lambda (element)
         (set! return (call/cc (lambda (resume)
                                 (set! state resume)
                                 (return element)))))
       lst)

      (return 'end)))

  (lambda ()
    (call/cc state)))

(define (make-coroutine-generator proc)
  (define void (if #f #f))
  (define return #f)
  (define resume #f)
  (define yield (lambda (v)
                  (call/cc (lambda (r)
                             (set! resume r)
                             (return v)))))
  (lambda ()
    (call/cc (lambda (cc)
               (set! return cc)
               (if resume
                   (resume void)
                   (begin (proc yield)
                          (set! resume (lambda (v)
                                         (return (eof-object))))
                          (return (eof-object))))))))

(define (generator proc)
  (define void (if #f #f))
  (define return #f)
  (define resume #f)
  (define (yield v)
    (call/cc (lambda (r)
               (set! resume r)
               (return v))))
  (define (next)
    (let ((value (call/cc
                  (lambda (cc)
                    (set! return cc)
                    (if resume
                        (resume void)
                        (begin
                          (proc yield)
                          (set! resume
                                (lambda (v)
                                  (return (eof-object))))
                          (return (eof-object))))))))
      `&(:value ,value :done ,(eof-object? value))))

  (let* ((iterator `((next . ,next)
                     (,Symbol.asyncIterator . ,(lambda () this)))))
    (alist->object iterator)))

(define-macro (lambda* args . body)
  `(lambda ,(cdr args)
     (generator (lambda (,(car args))
                  ,@body))))

(define range* (lambda* (yield n)
                        (do ((i 0 (+ i 1)))
                          ((>= i n))
                          (yield i))))

(define cc/result/2 '())

(let ((k #f) (i 0))
  (set! cc/result/2 (append cc/result/2 `(1 ,(call/cc (lambda (cc) (set! k cc) i)) 3)))
  (set! i (+ i 1))
  (if (< i 3)
      (let ((next (* i 10)))
        (k next))))

(define cc/result/3 '())

(let ((k #f) (i 0))
  (define l `(1 ,(call/cc (lambda (cc) (set! k cc) i)) 3))
  (set! cc/result/3 (append cc/result/3 (list l)))
  (set! i (+ i 1))
  (if (< i 3)
      (let ((next (* i 10)))
        (k next))))

(define saved #f)
(define str (string-append
             "foo "
             (call/cc (lambda (k)
                        (set! saved k)
                        "bar "))
             "boo"))

(define cc/result/4 str)
(saved "BAR ")
(define cc/result/5 str)


(test "procedure"
      (lambda (t)
        (t.is (procedure? (call/cc identity)) #t)))

(test "scope mutation"
      (lambda (t)
        (t.is cc/result/1 (list 3 2 1))))

(test "quasiquote append"
      (lambda (t)
        (t.is cc/result/2 '(1 20 3))
        (t.is cc/result/3 '((1 0 3) (1 10 3) (1 20 3)))))

(test "middle of string-append"
      (lambda (t)
        (t.is cc/result/4 "foo bar boo")
        (t.is cc/result/5 "foo BAR boo")))

(test "escape quasiquote"
      (lambda (t)
        (t.is (call/cc (lambda (return) `(1 2 ,(return 'escaped) 4))) 'escaped)))

;; a re-entrant continuation that loops within a single expression - matches
;; the behavior of Gambit, Chicken and Guile (sum of 0..5 = 15). The earlier
;; "base" test relied on REPL-style per-statement delimiting that no R7RS Scheme
;; provides inside a body (it would loop forever), so it was removed.
(test "re-entrant loop accumulates"
      (lambda (t)
        (t.is (let ((k #f) (sum 0) (i 0))
                (call/cc (lambda (c) (set! k c)))
                (set! sum (+ sum i))
                (set! i (+ i 1))
                (if (<= i 5) (k #f))
                sum)
              15)))

(test "double call/cc"
              (lambda (t)
                (define (repeat-string n item)
                  (apply string-append
                         (call/cc (lambda (return)
                                    (let ((next #f)
                                          (result '())
                                          (counter n))
                                      (call/cc (lambda (c)
                                                 (set! next c)))
                                      (set! counter (- counter 1))
                                      (set! result (cons item result))
                                      (if (zero? counter)
                                          (return result)
                                          (next)))))))

                (t.is (repeat-string 5 "x") "xxxxx")
                (t.is (repeat-string 2 "1") "11")))

(test "don't call after call continuation"
      (lambda (t)
        (let ((x #f))
          (let ((val (call/cc (lambda (cont)
                                (cont 5)
                                (set! x #t)))))
            (t.is val 5)
            (t.is x #f)))))

(test "calling continuation"
      (lambda (t)
        (t.plan 1)
        (let ((x #f))
          (let ((value (call/cc identity)))
            (if (procedure? value)
                (value #t)
                (t.is value #t))))))


(test "make-range"
              (lambda (t)
                (define (make-range from to)
                  (call/cc
                   (lambda (return)
                     (let ((result '()))
                       (let ((loop (call/cc (lambda (k) k))))
                         (set! result (cons (call/cc
                                             (lambda (append)
                                               (if (< from to)
                                                   (append from)
                                                   (return (reverse result)))))
                                            result))
                         (set! from (+ from 1))
                         (loop loop))))))

                (t.is (make-range 0 10) '(0 1 2 3 4 5 6 7 8 9))
                (t.is (make-range 10 20) '(10 11 12 13 14 15 16 17 18 19))))

(test "return"
      (lambda (t)
        (let ((called #f))

          (define (bar)
            (set! called #t))

          (define (foo)
            (call/cc (lambda (return)
                       (return 10)
                       (bar))))

          (t.is (foo) 10)
          (t.is called #f))))

(test "calling"
      (lambda (t)
        (let ((called))
          (t.is (let ((my-val (call/cc (lambda (c) c))))
                  (if (procedure? my-val)
                      (my-val 10)
                      (begin
                        (set! called #t)
                        my-val)))
                10)
          (t.is called #t))))

;; example that found a bug in BiwaScheme
;; https://github.com/biwascheme/biwascheme/issues/257
(test "saving/restoring environment"
      (lambda (t)
        (let ((result (call/cc (lambda (return)
                                 (let ((n 5)
                                       (result (list))
                                       (k #f))
                                   (set! result (append result (list (call/cc (lambda (return)
                                                                                (set! k return)
                                                                                "Hello")))))
                                   (when #t
                                     (if (zero? n)
                                         (return result))
                                     (set! n (- n 1))
                                     (k (string-append "Hello <" (number->string n) ">"))))))))

          (t.is result '("Hello <0>")))))

;; A continuation captured inside a syntax-rules macro body must work across the
;; macro boundary - both when the expansion contains the call/cc loop and when a
;; continuation captured inside a macro (here the built-in `when`) is re-entered.
;; Verified to match Gambit, Chicken and Guile.
(test "re-entry across a syntax-rules macro"
      (lambda (t)
        ;; the loop lives inside the macro expansion; `k` is introduced
        ;; hygienically by the macro, the rest comes from the use site
        (define-syntax repeat-until
          (syntax-rules ()
            ((_ counter limit body ...)
             (let ((k #f))
               (call/cc (lambda (c) (set! k c)))
               body ...
               (set! counter (+ counter 1))
               (if (< counter limit) (k #f))))))
        (t.is (let ((i 0) (k '()))
                (repeat-until i 3
                  (set! k (cons i k)))
                (reverse k))
              '(0 1 2))
        ;; a continuation captured inside a `when` (a syntax-rules macro) and
        ;; re-entered from outside it
        (t.is (let ((k #f) (n 0) (out '()))
                (when #t
                  (call/cc (lambda (c) (set! k c)))
                  (set! out (cons n out))
                  (set! n (+ n 1)))
                (if (< n 3) (k #f))
                (reverse out))
              '(0 1 2))))


(test "coroutine generator"
      (lambda (t)
        (define (make-coroutine-generator proc)
          (define return #f)
          (define resume #f)
          (define yield (lambda (v)
                          (call/cc (lambda (r)
                                     (set! resume r)
                                     (return v)))))
          (lambda ()
            (call/cc (lambda (cc)
                       (set! return cc)
                       (if resume
                           (resume (if #f #f))  ; void? or yield again?
                           (begin (proc yield)
                                  (set! resume (lambda (v)
                                                 (return (eof-object))))
                                  (return (eof-object))))))))


        (define counter (make-coroutine-generator
                         (lambda (yield)
                           (do ((i 0 (+ i 1)))
                             ((<= 3 i))
                             (yield i)))))

        (t.is (let iter ((i (counter))
                          (result '()))
                 (if (eof-object? i)
                     (reverse result)
                     (iter (counter) (cons i result))))
              '(0 1 2))))

;; https://docs.scheme.org/surveys/petrofsky-catastrophe/
(test "Petrofsky catastrophe"
      (lambda (t)
        (t.is (call/cc (lambda (c) (0 (c 1)))) 1)))

;; a continuation invoked from a later statement re-runs the WHOLE rest of the
;; body in every R7RS Scheme (verified against Gambit/Chicken/Guile), so the
;; loop must be self-contained inside a single expression. The old
;; "should execute twice" / "should work with quasiquote list" tests invoked the
;; continuation from a statement *after* the assertion, which requires REPL-style
;; per-statement delimiting that no R7RS Scheme (or LIPS) provides - they were
;; replaced with the equivalent self-contained versions below.
(test "re-entrant loop collects values"
      (lambda (t)
        (t.is (let ((k #f) (i 0) (acc '()))
                (let ((v (call/cc (lambda (c) (set! k c) i))))
                  (set! acc (cons v acc)))
                (set! i (+ i 1))
                (if (< i 3) (k (* i 100)))
                (reverse acc))
              '(0 100 200))))

(test "quasiquote with re-entrant call/cc"
      (lambda (t)
        (t.is (let ((k #f) (i 0) (acc '()))
                (let ((lst `(x ,(call/cc (lambda (c) (set! k c) i)) z)))
                  (set! acc (cons lst acc)))
                (set! i (+ i 1))
                (if (< i 3) (k (* i 100)))
                (reverse acc))
              '((x 0 z) (x 100 z) (x 200 z)))))

(test "list flipping"
      (lambda (t)
        (define result (let ((count 0) (flip #t) (x #f) (y #f) (result '()))
                         (set! result (cons (list (call/cc (lambda (cc) (set! x cc) count))
                                                  (call/cc (lambda (cc) (set! y cc) count)))
                                            result))
                         (if (== count 10)
                             (reverse result)
                             (let ((flap flip))
                               (set! flip (not flip))
                               (set! count (+ count 1))
                               (if flap
                                   (x count)
                                   (y count))))))
        (t.is result
              '((0 0) (1 1) (1 2) (3 3) (3 4) (5 5) (5 6) (7 7) (7 8) (9 9) (9 10)))))

(test "continuation escapes the try body (no throw)"
      (lambda (t)
        ;; invoking a continuation captured outside the try jumps straight out;
        ;; the catch clause never runs because nothing was thrown
        (t.is (call/cc (lambda (k) (try (k 'escaped) (catch (e) 'caught))))
              'escaped)
        ;; a continuation used inside the body returns normally as the try value
        (t.is (try (call/cc (lambda (k) (+ 1 (k 41)))) (catch (e) 'no)) 41)))

(test "continuation escapes from the catch clause"
      (lambda (t)
        (t.is (call/cc (lambda (k)
                         (try (throw "x") (catch (e) (k 'from-catch)))))
              'from-catch)))

(test "escaping a try removes its handler (no stale leak)"
      (lambda (t)
        ;; the inner try is escaped via k *without* throwing, so its handler
        ;; must NOT catch the later (throw "x") - only the outer try may
        (t.is (let ((log '()))
                (try (begin
                       (call/cc (lambda (k)
                                  (try (k 1)
                                       (catch (e) (set! log (cons 'inner log))))))
                       (throw "x"))
                     (catch (e) (set! log (cons 'outer log))))
                (reverse log))
              '(outer))
        ;; two escaped tries must not leave handlers that swallow a later throw
        (t.is (let ((log '()))
                (call/cc (lambda (k1) (try (k1 1) (catch (e) (set! log (cons 'A log))))))
                (call/cc (lambda (k2) (try (k2 2) (catch (e) (set! log (cons 'B log))))))
                (try (throw "z") (catch (e) (set! log (cons 'C log))))
                (reverse log))
              '(C))))

(test "re-entering a try re-arms its handler (retry)"
      (lambda (t)
        ;; k is captured inside the body; the catch re-invokes it, re-entering
        ;; the body - the handler must be active again so the next throw is caught
        (t.is (let ((k #f) (i 0) (log '()))
                (try (begin
                       (call/cc (lambda (c) (set! k c)))
                       (set! i (+ i 1))
                       (set! log (cons i log))
                       (if (< i 3) (throw "retry")))
                     (catch (e) (if k (k #f))))
                (reverse log))
              '(1 2 3))
        ;; the value passed to the re-invoked continuation flows back in
        (t.is (let ((k #f) (n 0) (out '()))
                (try (begin
                       (set! out (cons (call/cc (lambda (c) (set! k c) n)) out))
                       (set! n (+ n 1))
                       (if (< n 3) (throw "again")))
                     (catch (e) (k n)))
                (reverse out))
              '(0 1 2))))

(test "exceptions cross lambda/continuation boundaries"
      (lambda (t)
        ;; throw inside a called lambda is caught by an enclosing try
        (t.is (let ()
                (define (boom) (throw "kaboom"))
                (try (begin (boom) 'no) (catch (e) e.message)))
              "kaboom")
        ;; nested try + rethrow from inner catch is caught by outer
        (t.is (try (try (throw "inner") (catch (e) (throw "rethrown")))
                   (catch (e) e.message))
              "rethrown")))

(test "parameterize with call/cc escape"
      (lambda (t)
        (define p (make-parameter 1))
        ;; escaping the body with a continuation returns the inner value and
        ;; skips the surrounding computation
        (define result
          (call/cc
           (lambda (k)
             (parameterize ((p 2))
               (+ 100 (k (p)))))))
        (t.is result 2)
        ;; after leaving parameterize the value reverts
        (t.is (p) 1)))

(test "parameterize body runs once with call/cc"
      (lambda (t)
        ;; guards against the body being evaluated twice when a continuation
        ;; escapes across the parameterize boundary
        (define p (make-parameter 'out))
        (define count 0)
        (define v
          (call/cc
           (lambda (k)
             (parameterize ((p 'in))
               (set! count (+ count 1))
               (k (p))))))
        (t.is v 'in)
        (t.is count 1)))

(test "return from list"
      (lambda (t)
        (let ((test (list->array (list 1 2 3 4))) (y 10))
          (t.is (test.map (lambda (x)
                            (call/cc (lambda (return)
                                       (0 (return (* x y)))))))
                (list->array (list 10 20 30 40))))))

(test "retry"
      (lambda (t)
        (t.is (let ((result ()) (i 0))
                (define retry (call/cc (lambda (cc) cc)))
                (set! result (cons i result))
                (set! i (+ i 1))
                (if (< i 5)
                    (retry retry)
                    (reverse result)))
              '(0 1 2 3 4))))

(test "goto"
      (lambda (t)
        (t.is (let ((result ()))
                ((call/cc ; <= there is an apply in the saved context
                  (lambda (goto)
                    (letrec ((start (lambda ()
                                      (set! result (append result (list "start")))
                                      (goto next)))
                             (next  (lambda ()
                                      (set! result (append result (list "next")))
                                      (goto last)))
                             (last  (lambda ()
                                      (set! result (append result (list "last")))
                                      "done")))
                      start))))
                result)
              '("start" "next" "last"))))

(test "iterator"
      (lambda (t)
        (define gen (make-iterator '(0 1 2)))

        (t.is 0 (gen))
        (t.is 1 (gen))
        (t.is 2 (gen))
        (t.is 'end (gen))))

(test "exit let loop"
      (lambda (t)
        (t.plan 1)

        (call/cc (lambda (exit)
                   (let loop ((lst (list 1 2 3 4)))
                     (if (not (null? lst))
                         (let ((x (car lst)))
                           (t.is x 1)
                           (exit)
                           (loop (cdr lst)))))))))

(test "exit recursive function"
      (lambda (t)
        (t.plan 1)

        (define (loop fn lst)
          (if (not (null? lst))
              (let ((x (car lst)))
                (fn x)
                (apply loop fn (list (cdr lst))))))

        (call/cc (lambda (exit)
                   (loop (lambda (x)
                           (t.is x 1)
                           (exit))
                         (list 1 2 3 4))))))

(test "exit for-each"
      (lambda (t)
        (t.plan 1)
        (call/cc (lambda (exit)
                   (for-each (lambda (x)
                               (t.is x 1)
                               (exit))
                             (list 1 2 3 4))))))


(test "number generator"
      (lambda (t)
        (t.is (let ()
                (define result ())
                (define i 0)
                (define counter #f)

                (define (make-counter n)
                  (let ((m (call/cc
                            (lambda (cont)
                              (begin
                                (set! counter cont)
                                0)))))
                    (begin
                      (set! n (+ n 1))
                      (+ m n))))
                (make-counter 0)
                (set! result (cons i result))
                (set! i (+ i 1))
                (if (< i 10)
                    (counter 0)
                    (reverse result)))
              '(0 1 2 3 4 5 6 7 8 9))))

(test "coroutine-generator named loop"
      (lambda (t)
        (define counter (make-coroutine-generator
                 (lambda (yield)
                   (let loop ((i 0))
                     (if (< i 3)
                         (begin
                           (yield i)
                           (loop (+ i 1))))))))
        (t.is (counter) 0)
        (t.is (counter) 1)
        (t.is (counter) 2)
        (t.is (counter) (eof-object))))

(test "coroutine-generator do loop"
      (lambda (t)
        (define counter (make-coroutine-generator
                 (lambda (yield)
                   (do ((i 0 (+ i 1)))
                     ((<= 3 i))
                     (yield i)))))

        (t.is (counter) 0)
        (t.is (counter) 1)
        (t.is (counter) 2)
        (t.is (counter) (eof-object))))

(test "js generator as iterator"
      (lambda (t)
        (define x (range* 2))

        (t.is (. (x.next) "value") 0)
        (t.is (. (x.next) "value") 1)
        (t.is (. (x.next) "value") (eof-object))))


(test "js generator to array"
      (lambda (t)
        (let ((gen (range* 10)))
          (t.is (procedure? (. gen Symbol.asyncIterator)) #t)

          (t.is (Array.fromAsync gen)
                (list->array (list 0 1 2 3 4 5 6 7 8 9))))))

(test "--> macro"
      (lambda (t)
        (define -->result '())

        (let ((i 0) (k #f))
          (define value (--> Array (from (call/cc (lambda (cc) (set! k cc) "foo bar")))))
          (set! -->result (append -->result (list value)))
          (set! i (+ i 1))
          (if (< i 3)
              (k (--> (* i 10) (toString)))))

        (t.is (map (lambda (x) (x.join "")) -->result) '("foo bar" "10" "20"))))

(test "exit macro"
      (lambda (t)
        (define-syntax syntax-rules-test
          (syntax-rules ()
            ((_ name ...)
             (call/cc (lambda (name)
                        ...)))))

        (define sr-eject #f)

        (define sr-result (syntax-rules-test
                           eject
                           (for-each (lambda (x)
                                       (eject x)
                                       (set! sr-eject #t))
                                     '(1 2 3 4))))
        (t.is sr-result 1)
        (t.is sr-eject #f)))
