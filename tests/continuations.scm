(test "contanation: procedure"
      (lambda (t)
        (t.is (procedure? (call/cc identity)) #t)))

(test.failing "continuations: base"
      (lambda (t)
        (define cont 0)
        (define result #f)

        (set! result (+ 2 (call/cc (lambda (cc)
                                     (set! cont cc)
                                     3))))
        (t.is result 5)
        (cont 4)
        (t.is result 6)))

(test.failing "continuations: double call/cc"
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

(test.failing "continuations: don't call after call continuation"
      (lambda (t)
        (let ((x #f))
          (let ((val (call/cc (lambda (cont)
                                (cont 5)
                                (set! x #t)))))
            (t.is val 5)
            (t.is x #f)))))

(test.failing "continuations: calling continuation"
      (lambda (t)
        (t.plan 1)
        (let ((x #f))
          (let ((value (call/cc identity)))
            (if (procedure? value)
                (value #t)
                (t.is value #t))))))


(test.failing "continuations: make-range"
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

(test.failing "continuations: return"
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

(test.failing "continuations: calling"
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
(test.failing "continuations: saving/restoring environment"
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

(test.failing "continuations: scope mutation"
      (lambda (t)
        (define counter '())

        (define (make-counter n)
          (let ((m (call/cc
                    (lambda (cont)
                      (begin
                        (set! counter cont)
                        0)))))
            (begin
              (set! n (+ n 1))
              (+ m n))))

        (t.is (make-counter 0) 1)
        (t.is (counter 0) 2)
        (t.is (counter 0) 3)))


(test.failing "continuations: coroutine generator"
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
(test.failing "continuations: Petrofsky catastrophe"
      (lambda (t)
        (t.is (call/cc (lambda (c) (0 (c 1)))) 1)))

(test.failing "continuations: should execute twice"
      (lambda (t)
        (t.plan 2)
        (let ((i 0) (k #f))
          (t.is (list 1 (call/cc (lambda (c) (set! k c) i)) 3)
                (list 1 (* i 10) 3))
          (set! i (+ i 1))
          (if (<= i 2)
              (k (* i 10))))))
