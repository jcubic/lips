(load "./lib.scm")

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
(assert `(list ,(+ 1 2) ,@(list 1 2 3)) '(3 1 2 3))
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

(pprint '(define foo (lambda (x)
                       (+ x x))))

#;(print '>(new Promise (lambda (resolve)
                        (setTimeout (lambda ()
                                      (print "<XXX>")
                                      (resolve 10))
                                    1000))))


#;(let ((x 10))
  (let ((y 20))
    (ignore (print (stack-trace (call/cc (lambda (cc) cc)))))))

#;(let ((result ()))
  (let ((value (ignore (new Promise (lambda (resolve)
                                      (setTimeout (lambda ()
                                                    (set! result (cons "x" result))
                                                    (resolve))
                                                  1000)))
                       (print result)
                       (assert result (list "x" #void)))))
    (set! result (cons value result))
    (assert result '(#void))))

#;(print (try
        (throw "Nasty")
        (catch (e)
               e.message)))

;; internal LIPS code debugger
#;(let-env lips.env.__parent__
         (define DEBUG "expander"))

;;(macroexpand '(hello 10))

#;(define-macro (foo code)
  (let ((x (gensym)))
    `(list ',x ',code)))

#;(assert (foo (1 2 3)) '(#:g1 (1 2 3)))

#;(let ((k #f) (i 0))
  (display `(1 ,(call/cc (lambda (cc) (set! k cc) i)) 3))
  (newline)
  (set! i (+ i 1))
  (if (< i 3)
      (k (* i 10))))

;; example quasiquote cc/ `(1 <x> <y>) (<x> 10) (<y> 20)

;; TODO:
;; - [x] lambda continuation
;; - [x] Stack trace
;; - [x] generators
;; - [x] named let
;; - [x] do and while
;; - [x] syntax extensions
;; - [x] load
;; - [ ] quote promise (move macro to js)
;; - [ ] ignore
;; - [ ] try..catch
;; - [ ] quasiquote
;; - [ ] macro for define
;; - [ ] --> and object literals
;; - [ ] syntax-rules
;; - [ ] macroexpand
;; - [ ] dynamic scope
;; - [ ] bind / unbind
;; - [ ] box / unbox
;; - [ ] loading bootstrap.scm
;; - [ ] standard REPL
;; - [ ] automated tests

;;(print "DONE")
;;(print (concat "tests passed: " (passed.toString) "/" (tests.toString)))
