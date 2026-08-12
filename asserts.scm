(load "./lib.scm")

(define-syntax syntax-rules-test
  (syntax-rules ()
    ((_ name ...)
     (call/cc (lambda (name)
                ...)))))

(define sr-eject #f)

(define sr-result (syntax-rules-test eject
                           (for-each (lambda (x)
                                       (eject x)
                                       (set! sr-eject #t))
                                     '(1 2 3 4))))
(assert sr-result 1)
(assert sr-eject #f)

(define fs (require "fs/promises"))

(let ((file (fs.readFile "./asserts.scm" "utf8")))
  (assert (instanceof lips.LString file) #t))

(define (syntax-test x)
  (call/cc (lambda (return)
             (for-each (lambda (item)
                         (return item)
                         (print x))
                       x))))

(set-special! "&&" 'syntax-test lips.specials.LITERAL)
(assert &&(1 2 3) 1)

(define-macro (test x)
  (let ((name (gensym "name")))
    `(let ((,name ,x))
       (list ,name))))

(assert (let ((foo 'hello))
          (test foo))
        '(hello))

(define-macro (def name value)
  (let ()
    `(define ,name ,value)))

(def foo 10)
(assert foo 10)


(define-macro (hello x)
  (let ((a (gensym)))
    (list 'let (list (list a x))
          (list 'if a
                (list 'test a)))))

(define-macro (test x)
  (list 'list x))

(assert (hello 10) (list 10))

(assert (let ((x 10)) (list (+ x 2))) (list 12))

(assert (let ((list (list->array (list 1 2 3 4))))
          (list.filter (lambda (x) (>= x 3))))
        (list->array (list 3 4)))

(assert (type list) "function")

(assert (let ((list (list->array (list 1 2 3 4))) (y 10))
          (list.map (lambda (x)
                      (call/cc (lambda (return)
                                 (0 (return (* x y))))))))
        (list->array (list 10 20 30 40)))

(define (sum n acc)
  (if (<= n 0)
      acc
      (sum (- n 1) (+ acc n))))

(assert (sum 1000 0) 500500)

(define (sum-let n)
  (let loop ((n n) (acc 0))
    (if (<= n 0)
        acc
        (loop (- n 1) (+ acc n)))))


(assert (sum-let 100 0) 5050)

(assert ((lambda (x) (* x x)) 10) 100)

(assert (Promise.resolve 10) 10)


(assert (let ((count 0) (flip #t) (x #f) (y #f) (result '()))
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
                    (y count)))))
        '((0 0) (1 1) (1 2) (3 3) (3 4) (5 5) (5 6) (7 7) (7 8) (9 9) (9 10)))

(assert (let ()
          (cons (list 0 1) (cons (list 0 1) ())))
        '((0 1) (0 1)))

(assert ((lambda (fn)
           (fn 10))
         (lambda (x)
           (+ x x)))
        20)

(assert (let ((i 10) (result ()))
          (let ((loop (call/cc (lambda (k) k))))
            (if (<= i 0)
                result
                (begin
                  (set! i (- i 1))
                  (set! result (cons i result))
                  (loop loop)))))
        '(0 1 2 3 4 5 6 7 8 9))

(assert (let ((i 10) (result ()))
          ((lambda (loop)
             (if (<= i 0)
                 result
                 (begin
                   (set! i (- i 1))
                   (set! result (cons i result))
                   (loop loop))))
           (call/cc (lambda (cc) cc))))
        '(0 1 2 3 4 5 6 7 8 9))

(assert (let ((a 10) (b 20))
          (+ a b))
        30)

(assert (call/cc (lambda (c) (0 (c 1)))) 1)

(assert (let ()
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
        '(0 1 2 3 4 5 6 7 8 9))

(define-macro (hello x)
  (let ((a (gensym)))
    (list 'let (list (list a x))
          (list 'if a
                (list 'test a)))))

(define-macro (test x)
  (list 'list x))

(assert (test 10) '(10))
(assert `(list ,(+ 1 2) ,@(list 1 2 3)) '(list 3 1 2 3))
(assert (array->list (list->array (list 1 2 3))) '(1 2 3))

(define (eof-object)
  lips.eof)

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

(define counter (make-coroutine-generator
                 (lambda (yield)
                   (let loop ((i 0))
                     (if (< i 3)
                         (begin
                           (yield i)
                           (loop (+ i 1))))))))

(assert (counter) 0)
(assert (counter) 1)
(assert (counter) 2)
(assert (counter) (eof-object))

(define counter (make-coroutine-generator
                 (lambda (yield)
                   (do ((i 0 (+ i 1)))
                     ((<= 3 i))
                     (yield i)))))

(assert (counter) 0)
(assert (counter) 1)
(assert (counter) 2)
(assert (counter) (eof-object))

(assert (let* ((a 10) (b (* a a)))
          (+ a b))
        110)

(assert (let* ((x 10) (x (+ x x)) (x (+ x x)))
          x)
        40)

(assert (letrec ((x 10) (foo (lambda (y) (* x y))))
          (foo 20))
        200)

(assert (letrec* ((x 10) (foo (lambda (y) (* x y))))
          (foo 20))
        200)

(assert (letrec ((loop (lambda (x acc)
                         (if (<= x 0)
                             acc
                             (loop (- x 1) (cons x acc))))))
          (loop 10 ()))
        (list 1 2 3 4 5 6 7 8 9 10))

(assert (letrec* ((x 10) (y x)) y) 10)

(assert (let ((x 10) (y 20)) (+ x y)) 30)

(assert (let ((list 10)) list) 10)
(assert (let* ((list 20)) list) 20)
(assert (list 10) '(10))

(assert (letrec* ((foo (lambda (x acc)
                         (if (<= x 0)
                             acc
                             (foo (- x 1) (cons x acc))))))
          (foo 10 ()))
        (list 1 2 3 4 5 6 7 8 9 10))

(assert (let ((i 10) (letrec 10) (result ()))
          (while (> i 0)
            (set! i (- i 1))
            (set! result (cons i result)))
          result)
        (list 0 1 2 3 4 5 6 7 8 9))

(assert (do ((i 0 (+ i 1)) (result ()))
          ((<= 3 i) result)
          (set! result (cons i result)))
        (list 2 1 0))

(assert (let ((letrec 10))
          (let loop ((i 10) (acc ()))
            (if (<= i 0)
                acc
                (loop (- i 1) (cons i acc)))))
        (list 1 2 3 4 5 6 7 8 9 10))


(define (alist->object alist)
  "(alist->object alist)

   Function that converts alist pairs to a JavaScript object."
  (typecheck "alist->object" alist (list "pair" "nil"))
  (alist.to_object))

(define (eof-object? obj)
  "(eof-object? arg)

   Checks if value is eof object, returned from input string
   port when there are no more data to read."
  (eq? obj eof))

(define (%result value done)
  (let ((result (alist->object ())))
    (set! result.done done)
    (set! result.value value)
    result))

(define (range n)
  (let ((iterator (alist->object ())))
    (set-obj! iterator "next" (lambda ()
                                (if (== n 0)
                                    (%result n #t)
                                    (let ((value n))
                                      (set! n (- n 1))
                                      (%result value #f)))))
    (set-obj! iterator Symbol.iterator (lambda () iterator))
    iterator))

(assert (Array.from (range 10))
        (list->array (list 10 9 8 7 6 5 4 3 2 1)))


(define (generator proc)
  (define void (if #f #f))
  (define return #f)
  (define resume #f)
  (define yield (lambda (v)
                  (call/cc (lambda (r)
                             (set! resume r)
                             (return v)))))
  (let ((iterator (alist->object ())))
    (set-obj! iterator "next" (lambda ()
                                (let ((value (call/cc (lambda (cc)
                                                        (set! return cc)
                                                        (if resume
                                                            (resume void)
                                                            (begin
                                                              (proc yield)
                                                              (set! resume (lambda (v)
                                                                             (return (eof-object))))
                                                              (return (eof-object))))))))
                                  (%result value (eof-object? value)))))
    (set-obj! iterator Symbol.asyncIterator (lambda () iterator))
    iterator))

(define (range n)
  (generator (lambda (yield)
               (do ((i 0 (+ i 1)))
                 ((>= i n) #null)
                 (yield i)))))


(define-macro (lambda* args . body)
  `(lambda ,(cdr args)
     (generator (lambda (,(car args))
                  ,@body))))

(define range (lambda* (yield n)
                       (do ((i 0 (+ i 1)))
                         ((>= i n))
                         (yield i))))

(define x (range 2))

(assert (. (x.next) "value") 0)
(assert (. (x.next) "value") 1)
(assert (. (x.next) "value") (eof-object))

(assert (Array.fromAsync (range 10))
        (list->array (list 0 1 2 3 4 5 6 7 8 9)))

(assert (Array.from (alist->object (list (cons "length" 10))) (lambda (_ i) i))
        (list->array (list 0 1 2 3 4 5 6 7 8 9)))


(let ((test (list->array (list 1 2 3 4))) (y 10))
  (assert (test.map (lambda (x)
                      (call/cc (lambda (return)
                                 (0 (return (* x y)))))))
          (list->array (list 10 20 30 40))))

(define-macro (def name x)
  (let ((g (gensym)))
    (list 'define name (list 'list x x))))

(def foo 10)

(assert foo '(10 10))

(define stack (let ((x 10))
                (let ((y 20))
                  (stack-trace (call/cc (lambda (cc) cc))))))

(assert stack
        "[0]: (define stack (let ((x 10)) (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc))))))
         [1]: (let ((x 10)) (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc)))))
         [2]: (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc))))
         [3]: (stack-trace (call/cc (lambda (cc) cc)))
         [4]: (call/cc (lambda (cc) cc))
         [5]: (lambda (cc) cc)")

(set-special! "::" 'syntax)

(define (syntax x)
  (list 'quote x))

(assert ::1000 '1000)
(assert ::(1 2 3) '(1 2 3))


(assert (+ (Promise.resolve 10)
           (Promise.resolve 10)
           10)
        30)

(assert (let ((result ()) (i 0))
          (define retry (call/cc (lambda (cc) cc)))
          (set! result (cons i result))
          (set! i (+ i 1))
          (if (< i 5)
              (retry retry)
              (reverse result)))
        '(0 1 2 3 4))

(assert ((let ((λ lambda)) (λ (x) (* x x))) 10) 100)

(assert (let ((result ()))
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
        '("start" "next" "last"))

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

(define gen (make-iterator '(0 1 2)))

(assert 0 (gen))
(assert 1 (gen))
(assert 2 (gen))
(assert 'end (gen))

(define $:import (global.eval "(x) => import(x)"))

(define scheme (. ($:import "../lib/js/pprint.js") "default"))

(define (pprint code)
  (print (scheme code)))

(define (format code . rest)
  "(format code [prefix])

   function return syntax highlighted code but the lines are prefixed
   with a given string. So you can add a prefix before the expression
   and the the will be indented properly."
  (let ((code (scheme code)))
    (if (not (null? rest))
        (let ((prefix (concat "\n" (car rest))))
          (code.replace #/\n/ prefix))
        code)))

(assert (repr '>(new Promise (lambda (resolve)
                               (setTimeout (lambda ()
                                             (resolve 10))
                                           1000))))
        "#<js-promise (pending)>")

(let ((result ()) (promise #f))
  (let ((value (ignore (let ((p '>(new Promise (lambda (resolve)
                                                 (setTimeout (lambda ()
                                                               (set! result (cons "x" result))
                                                               (resolve))
                                                             1000)))))
                         (set! promise p)
                         (await p)
                         (assert result (list "x" #void))))))
    (set! value (await value))
    (set! result (cons value result))
    (assert result '(#void))
    (await promise)))

(call/cc (lambda (exit)
           (let loop ((lst (list 1 2 3 4)))
             (if (not (null? lst))
                 (let ((x (car lst)))
                   (assert x 1)
                   (exit)
                   (loop (cdr lst)))))))

(define (loop fn lst)
  (if (not (null? lst))
      (let ((x (car lst)))
        (fn x)
        (apply loop fn (list (cdr lst))))))

(call/cc (lambda (exit)
           (loop (lambda (x)
                   (assert x 1)
                   (exit))
                 (list 1 2 3 4))))

(call/cc (lambda (exit)
           (for-each (lambda (x)
                       (assert x 1)
                       (exit))
                     (list 1 2 3 4))))

(define saved #f)
(define str (string-append
             "foo "
             (call/cc (lambda (k)
                        (set! saved k)
                        "bar "))
             "boo"))

(assert str "foo bar boo")
(saved "BAR ")
(assert str "foo BAR boo")

(define counter '())
(define result '())

(define (make-counter n)
  (let ((m (call/cc
            (lambda (cont)
              (begin
                (set! counter cont)
                0)))))
    (begin
      (set! n (+ n 1))
      (+ m n))))

(set! result (cons (make-counter 0) result))
(counter 0)
(counter 0)
(assert result (list 3 2 1))


(define (loop fn lst)
  (if (not (null? lst))
      (begin
        (fn (car lst))
        (loop fn (cdr lst)))))

(define (iterate list)
  (make-coroutine-generator (lambda (yield)
                              (for-each yield list))))

(define iter (iterate '(1 2 3)))
(assert (iter) 1)
(assert (iter) 2)
(assert (iter) 3)
(assert (iter) (eof-object))

(assert (map apply
            (list + - * /)
            (list (list 1 2) (list 10 5) (list 3 4) (list 20 2)))
        '(3 5 12 10))

(assert (map (lambda (a b) (+ a b)) '(1 2 3 4) '(10 10 10 10))
        '(11 12 13 14))

(let ((i 1))
  (for-each (lambda (x)
              (assert x i)
              (set! i (+ i 1)))
            '(1 2 3 4)))

(define list-product
  (lambda (s)
    (call/cc
     (lambda (exit)
       (let recur ((s s))
         (if (null? s) 1
             (if (= (car s) 0) (exit 0)
                 (* (car s) (recur (cdr s))))))))))

(assert (list-product '(0 1 2 3 4 10 20 30)) 0)
(assert (list-product '(1 2 3 4 10 20 30)) 144000)

(define -->result '())

(let ((i 0) (k #f))
  (define value (--> Array (from (call/cc (lambda (cc) (set! k cc) "foo bar")))))
  (set! -->result (append -->result (list value)))
  (set! i (+ i 1))
  (if (< i 3)
      (k (--> (* i 10) (toString)))))

(assert (map (lambda (x) (x.join "")) -->result) '("foo bar" "10" "20"))

(assert (try
         (throw "Nasty")
         (catch (e)
                e.message))
        "Nasty")

(assert (sort '(3 2 1) <) '(1 2 3))

(define result '())

(let ((k #f) (i 0))
  (set! result (append result `(1 ,(call/cc (lambda (cc) (set! k cc) i)) 3)))
  (set! i (+ i 1))
  (if (< i 3)
      (let ((next (* i 10)))
        (k next))))

(assert result '(1 20 3))

(set! result '())

(let ((k #f) (i 0))
  (define l `(1 ,(call/cc (lambda (cc) (set! k cc) i)) 3))
  (set! result (append result (list l)))
  (set! i (+ i 1))
  (if (< i 3)
      (let ((next (* i 10)))
        (k next))))

(assert result '((1 0 3) (1 10 3) (1 20 3)))

(define (test . code)
  `(let ()
     ,@(map (lambda (x)
              `(print ,x))
            code)))

(assert (test 1 2 3 4) '(let ()
                          (print 1)
                          (print 2)
                          (print 3)
                          (print 4)))

;; internal LIPS code debugger
#;(let-env lips.env.__parent__
         (define DEBUG "expander"))



(define (foo) 'bar)

;; T1 splice empty list
(assert `(x ,@() x) '(x x))

;; T11 join symbol (improper via splicing an atom)
(assert (let ((x 'foo)) `(a ,@x)) '(a . foo))

;; function call
(define (fun a b) (+ a b))
(assert `(1 2 3 ,(fun 2 2) 5) '(1 2 3 4 5))

;; value
(define value 42)
(assert `(1 2 3 ,value 4) (list 1 2 3 value 4))

;; single splice
(define (f2 a b) (list a b))
(assert `(1 2 3 ,@(f2 4 5) 6) '(1 2 3 4 5 6))

;; single pair
(assert `(1 . 2) '(1 . 2))
(assert `(,(car (list 1 2 3)) . 2) '(1 . 2))
(assert `(1 . ,(cadr (list 1 2 3))) '(1 . 2))
(assert `(,(car (list 1 2 3)) . ,(cadr (list 1 2 3))) '(1 . 2))

;; pair syntax
(assert `(,(car (list 1 2 3)) . (1 2 3)) (list 1 1 2 3))

;; alist with values
(assert `((1 . ,(car (list 1 2)))
          (2 . ,(cadr (list 1 "foo"))))
        '((1 . 1) (2 . "foo")))

;; nested backquote processing
(assert `(1 2 3 ,(cadr `(1 ,(concat "foo" "bar") 3)) 4)
        '(1 2 3 "foobar" 4))

;; ignore splice on empty list
(assert `(list ,@(list)) '(list))

;; improper list splicing
(assert (let ((x '(1 2 3))) `(foo . ,x)) '(foo 1 2 3))

;; unquote-splicing and improper list
(assert (let ((result `((foo ,(- 10 3)) ,@(cdr '(c)) . ,(car '(cons)))))
          result)
        '((foo 7) . cons))

;; T9 quasiquote quote unquoted
(assert `',(foo) '(quote bar))
(assert (let ((x 'foo)) `',x) '(quote foo))

;; T10 unquote simple and double unquote symbol
(assert (let ((y 20)) `(let ((x 10)) `(list ,x ,,y)))
        '(let ((x 10)) (quasiquote (list (unquote x) (unquote 20)))))

;; T7 single unquote
(assert `(let ((name 'x)) `(let ((name 'y)) `(list ',name)))
        '(let ((name (quote x)))
           (quasiquote (let ((name (quote y)))
                         (quasiquote (list (quote (unquote name))))))))

;; T12 unquote from double quotation
(assert (let ((x '(1 2)))
          `(let ((x '(2 3)))
             (begin
               `(list ,(car x))
               `(list ,,(car x)))))
        '(let ((x (quote (2 3))))
           (begin
             (quasiquote (list (unquote (car x))))
             (quasiquote (list (unquote 1))))))

;; multiple backquote/unquote
(assert ``(a ,,(+ 1 2) ,(+ 3 4))
        '(quasiquote (a (unquote 3) (unquote (+ 3 4)))))

;; constant quasiquote (should be shared/eq)
(define (const) `(1 2))
(assert (eq? (const) (const)) #t)

;; should create new pair
(define (mk1 x) `(1 2 ,@x))
(assert (eq? (mk1 '(1)) (mk1 '(2))) #f)
(define (mk2 x) `(1 2 ,x))
(assert (eq? (mk2 10) (mk2 20)) #f)

;; T5b single-level nested unquote-splice kept as data
(assert `(1 `,@(list (+ 1 2)) 4)
        '(1 (quasiquote (unquote-splicing (list (+ 1 2)))) 4))

;; T8 double backquote and unquote on list (eval)
(assert (eval (let ((x '((list 1 2 3) (list 4 5 6) (list 7 8 9))))
                `(list `(,,@x)))
              (interaction-environment))
        '(((1 2 3) (4 5 6) (7 8 9))))

;; T6 return list (eval)
(assert (eval (let ((x '((list 1 2 3) (list 1 2 3) (list 1 2 3))))
                `(list `(,@,(car x))))
              (interaction-environment))
        '((1 2 3)))

;; T3 double splice the list (eval)
(define t3-expr (let ((x '((list 1 2 3) (list 4 5 6) (list 7 8 9))))
                  `(list `(,@,@x))))
(assert t3-expr
        '(list (quasiquote ((unquote-splicing (list 1 2 3)
                                              (list 4 5 6)
                                              (list 7 8 9))))))
(assert (eval t3-expr (interaction-environment)) '((1 2 3 4 5 6 7 8 9)))

;; T4 backquote & unquote multiple times
(assert `(```,,,,@(list 1 2))
        '((quasiquote (quasiquote (quasiquote (unquote (unquote (unquote 1 2))))))))

;; T5a quasiquote unquote-splice (extreme)
(assert `(1 ```,,@,,@(list (+ 1 2)) 4)
        '(1 (quasiquote (quasiquote (quasiquote (unquote (unquote-splicing (unquote 3)))))) 4))

;; T15 double unquote-splicing (#362)
(assert (let ((x '(1 2 3)) (y '(11 22 33)) (l '(x y)))
          ``(,@,@l ,@,@l))
        '(quasiquote ((unquote-splicing x y) (unquote-splicing x y))))

;; --- vectors ---
(assert `#(,(+ 1 2) ,(+ 2 3) ,(Promise.resolve 7)) #(3 5 7))
(assert `(foo #(10 ,@(list 1 2 3))) '(foo #(10 1 2 3)))

;; --- objects (compared by property access, repr is #<Object>) ---
(define obj1 `&(:foo ,(+ 1 2) :bar ,(Promise.resolve 10)))
(assert (. obj1 'foo) 3)
(assert (. obj1 'bar) 10)

(define obj-in-list `(foo &(:foo ,(+ 1 2) :bar 10)))
(assert (car obj-in-list) 'foo)
(assert (. (cadr obj-in-list) 'foo) 3)
(assert (. (cadr obj-in-list) 'bar) 10)

(define cc-log '())
(let ((k #f) (i 0))
  (define v `(a ,(call/cc (lambda (cc) (set! k cc) i)) z))
  (set! cc-log (cons v cc-log))
  (set! i (+ i 1))
  (if (< i 3) (k (* i 100))))
(assert (reverse cc-log) '((a 0 z) (a 100 z) (a 200 z)))

;; escape continuation out of the middle of a build
(assert (call/cc (lambda (return) `(1 2 ,(return 'escaped) 4))) 'escaped)

;; re-entrant continuation captured inside an unquote-splicing
(define cc-log2 '())
(let ((k #f) (n 0))
  (define v `(x ,@(list (call/cc (lambda (c) (set! k c) n))) y))
  (set! cc-log2 (cons v cc-log2))
  (set! n (+ n 1))
  (if (< n 3) (k (* n 10))))
(assert (reverse cc-log2) '((x 0 y) (x 10 y) (x 20 y)))


(define cc-promises '())
(let ((k #f) (i 0))
  (define p '>(Promise.resolve (call/cc (lambda (cc) (set! k cc) i))))
  (set! cc-promises (cons p cc-promises))
  (set! i (+ i 1))
  (if (< i 3)
      (k (* i 10))))

(assert (reverse (map await cc-promises)) '(0 10 20))

;; example quasiquote cc/ `(1 <x> <y>) (<x> 10) (<y> 20)

;; TODO:
;; - [x] lambda continuation
;; - [x] Stack trace
;; - [x] generators
;; - [x] named let
;; - [x] do and while
;; - [x] syntax extensions
;; - [x] load
;; - [x] quote promise (move macro to js)
;; - [ ] ignore
;; - [x] try..catch
;; - [x] quasiquote
;; - [ ] macro for define
;; - [x] --> and object literals
;; - [ ] syntax-rules
;; - [ ] macroexpand
;; - [ ] dynamic scope
;; - [ ] bind / unbind
;; - [ ] box / unbox
;; - [ ] loading bootstrap.scm
;; - [ ] standard REPL
;; - [ ] automated tests

(print "DONE")
(print (concat "tests passed: " (passed.toString) "/" (tests.toString)))
