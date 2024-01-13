(define-macro (exec code)
  (lips.evaluate code &(:use_dynamic true)))

(test "dynamic: let"
      (lambda (t)
        (t.is (exec (begin
                      (define (f)
                        (let ((y 10))
                          (+ x y)))
                      (let ((x 10))
                        (f))))
              20)))

(test "dynamic: function parameters"
      (lambda (t)
        (t.is (exec (begin
                      (define (f y)
                        (+ x y))
                      (let ((x 10))
                        (f 10))))
              20)))

(test "dynamic: set"
      (lambda (t)
        (t.is (exec (begin
                      (define (f)
                        (set! x (* x x)))
                      (let ((x 10))
                        (f)
                        x)))
              100)))

;; https://www.reddit.com/r/lisp/comments/1943lg6/comment/khehb28/?context=3
(test "dynamic: stak"
      (lambda (t)
        (t.is
         (exec (begin
                 (define (stak x y z)
                   (stak-aux))

                 (define (stak-aux)
                   (if (not (< y x))
                       z
                       (let
                           ((x (let ((x (1- x))
                                     (y y)
                                     (z z))
                                 (stak-aux)))
                            (y (let ((x (1- y))
                                     (y z)
                                     (z x))
                                 (stak-aux)))
                            (z (let ((x (1- z))
                                     (y x)
                                     (z y))
                                 (stak-aux))))
                         (stak-aux))))
                      (stak 18 12 6)))
         7)))
