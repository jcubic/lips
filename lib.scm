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

(define (number->string n . rest)
  (if (null? rest)
      (n.toString)
      (n.toString (car rest))))

(define (symbol->string s)
  (let ((name s.__name__))
    (if (string? name) name (name.toString))))


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
