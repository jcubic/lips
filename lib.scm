(define tests 0)
(define passed 0)

(define-macro (assert a b)
  (let ((a_expr (gensym "a"))
        (b_expr (gensym "b")))
    `(let ((,a_expr (repr ,a))
           (,b_expr (repr ,b)))
       (set! tests (+ tests 1))
       (if (== ((. ,a_expr "cmp") ,b_expr) 0)
           (set! passed (+ passed 1))
           (print (concat "FAIL: "
                          ,a_expr
                          " != "
                          ,b_expr))))))

(define (zero? x)
  (== x 0))

(define = ==)
(define list->vector list->array)
(define vector->list array->list)
(define call-with-current-continuation call/cc)
(define string-append concat)

(define-macro (or . args)
  "(or expr1 expr2 ...)

   Macro that executes the values one by one and returns the first that is
   a truthy value. If there are no expressions that evaluate to true it
   returns false."
  (if (null? args)
      #f
      (if (null? (cdr args))
          (car args)
          (let ((name (gensym)))
            `(let ((,name ,(car args)))
               (if ,name ,name (or ,@(cdr args))))))))

(define-macro (and . args)
  "(and expr1 expr2 ...)

   Macro that evaluates each expression in sequence and if any value returns false
   it will stop and return false. If each value returns true it will return the
   last value. If it's called without arguments it will return true."
  (if (null? args)
      #t
      (if (null? (cdr args))
          (car args)
          `(if ,(car args) (and ,@(cdr args)) #f))))

;; map implementation based on https://stackoverflow.com/a/21629316/387194
(define (%some? function list)
  "(%some? function lst)

   Help function that check if function predicate return true for every elemet
   of the list. If argument is not a list it returns #f."
  (and (pair? list)
       (or (function (car list))
           (%some? function (cdr list)))))

(define (%map1 function list)
  "(%map1 function list)

   Helper single list map function, used by map."
  (let loop ((list list) (result ()))
    (if (null? list)
        (reverse result)
        (loop (cdr list)
              (cons (function (car list))
                    result)))))

(define (map function . lists)
  "(map fn list1 list2 ...)

   Higher-order function that calls function `fn` with each
   value of the list. If you provide more then one list as argument
   it will take each value from each list and call `fn` function
   with that many argument as number of list arguments. The return
   values of the fn calls are accumulated in a result list and
   returned by map."
  (let loop ((lists lists) (result '()))
    (if (%some? null? lists)
      (reverse result)
      (loop (%map1 cdr lists)
            (cons (apply function (%map1 car lists))
                  result)))))

(define (for-each . args)
  "(for-each fn list1 list2 ...)

   Higher-order function that calls function `fn` on each
   value of the argument. If you provide more than one list
   it will take each value from each list and call `fn` function
   with that many arguments as number of list arguments."
  (apply map args)
  #void)
