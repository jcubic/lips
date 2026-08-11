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
(define (interaction-environment)
  (current-environment))

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
  (let loop ((lists lists) (k (lambda (x) x)))
    (if (%some? null? lists)
        (k '())
        (loop (%map1 cdr lists)
              (lambda (rest)
                (k (cons (apply function (%map1 car lists)) rest)))))))

(define (for-each function . lists)
  "(for-each fn list1 list2 ...)

   Higher-order function that calls function `fn` on each
   value of the argument. If you provide more than one list
   it will take each value from each list and call `fn` function
   with that many arguments as number of list arguments."
  (let loop ((lists lists))
    (if (not (%some? null? lists))
        (begin
          (apply function (%map1 car lists))
          (loop (%map1 cdr lists))))))



(define (tail-recursive-map f lst)
  ;; Use a mutable box to store the result
  (let ((result '())
        (result-tail '()))
    (define (helper remaining-list)
      (if (null? remaining-list)
          ;; When the list is empty, return the accumulated result
          result
          (let ((new-element (f (car remaining-list))))
            ;; Create a new pair for the current element
            (let ((new-pair (cons new-element '())))
              ;; If this is the first element, initialize the result
              (if (null? result)
                  (set! result new-pair))
              ;; Always update the tail pointer
              (if (not (null? result-tail))
                  (set-cdr! result-tail new-pair))
              (set! result-tail new-pair))
            ;; Recurse with the rest of the list
            (helper (cdr remaining-list)))))
    ;; Start the recursion
    (helper lst)))


(define (consify expression)
  (if (pair? expression)
      (list 'cons
            (consify (car expression))
            (consify (cdr expression)))
      (cond ((null? expression) expression)
            ((symbol? expression) (list 'quote expression))
            (else expression))))

(set-special! "#" 'vector-literal lips.specials.SPLICE)

(define-macro (vector-literal . args)
  (if (not (or (pair? args) (eq? args '())))
      (throw (new Error (concat "Parse Error: vector require pair got "
                                (type args) " in " (repr args))))
      (let ((v (list->array args)))
        (Object.freeze v)
        v)))

(define (%key? x)
  (and (symbol? x)
       (== ((. x '__name__ 'indexOf) ":") 0)))

(define (%key->string x)
  ((. x '__name__ 'substring) 1))

(set-special! "&" 'object-literal lips.specials.SPLICE)

(define-macro (object-literal . args)
  (let ((obj (gensym "obj")))
    (let loop ((lst args) (body '()))
      (if (null? lst)
          `(let ((,obj (Object.fromEntries (Array))))
             ,@(reverse body)
             ,obj)
          (let* ((k (car lst))
                 (key (%key->string k))
                 (rest (cdr lst))
                 (has-value (and (pair? rest) (not (%key? (car rest)))))
                 (value (if has-value (car rest) #void)))
            (loop (if has-value (cddr lst) rest)
                  (cons `(set-obj! ,obj ,key ',value) body)))))))
