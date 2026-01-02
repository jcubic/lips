(define-macro (t.is a b)
  "(t.is a b)

   Helper comparator for ava. It use equal? so it match two lists and strings.
   It use undecumented API that allow to delete StackTrace when assertion fail."
  (let ((attempt (gensym))
        (a_name (gensym))
        (b_name (gensym)))
    `(let ((,attempt (t.try (lambda (e)
                              (let ((,a_name (round-number ,a))
                                    (,b_name (round-number ,b)))
                                (if (equal? ,a_name ,b_name)
                                    (--> e (pass))
                                    (--> e (fail (concat "failed: " (repr ,a_name true)
                                                         " != " (repr ,b_name true)
                                                         " in " (repr ',a true))))))))))
       (if (not (. ,attempt 'passed))
           (--> (. ,attempt 'errors)
                (forEach (lambda (e)
                           (set-obj! e 'savedError #void)))))
       (--> ,attempt (commit)))))

(define (round-number x . rest)
  "(round-number x)

  Rounds float numbers to a 10 numbers after decimal point.
  This fixes the aissue with V8 in Node 24."
  (let ((precision (if (null? rest) 10 (car rest))))
    (if (number? x)
        (cond ((string=? x.__type__ "float")
               (round-fixed x precision))
              ((and (string=? x.__type__ "complex")
                    (string=? x.__im__.__type__ "float")
                    (string=? x.__re__.__type__ "float"))
               (make-rectangular (round-fixed x.__re__ precision)
                                 (round-fixed x.__im__ precision)))
              ((and (string=? x.__type__ "complex")
                    (= x.__re__ 0)
                    (string=? x.__im__.__type__ "float"))
               (make-rectangular 0
                                 (round-fixed x.__im__ precision)))
              (else x))
        x)))

(define (round-fixed x . rest)
  "(round-fixed x)

   Rounds a number to a given presition"
  (let* ((precision (if (null? rest) 14 (car rest)))
         (factor (** 10 precision)))
    (if (big-float? x)
        (let-values (((int float) (split-number x)))
          (+ int (round-fixed float 4))) ;; arbitrary precision
        (/ (Math.round (* x factor))
           (exact->inexact factor)))))

(define (big-float? x)
  (and (number? x)
       (string=? x.__type__ "float")
       (not (infinite? x))
       (not (nan? x))
       (> (abs x) 1000))) ;; arbitrary big number

(define (split-number x)
  "(split-number x)

   Split float number into integer and fraction value."
  (let* ((a (Math.round x))
         (b (- x a)))
    (values a b)))

(define-macro (to.throw . body)
  "(to.throw code)

   If code throw exception it will return true, otherwise
   it will return false."
  (let ((result (gensym)))
    `(try (begin ,@body #f) (catch (e) #t))))

(define (%test-specs t specs)
  "(%test-specs t list)

   Function test list of specs (\"name\" function result . args)"
  (let iter ((specs specs))
    (if (not (null? specs))
        (let* ((spec (car specs))
               (name (car spec))
               (fn (cadr spec))
               (expected (caddr spec))
               (args (cdddr spec)))
          (let ((result (apply fn args)))
            (if (not (equal? result expected))
                (error (string-append "FAILED: "
                                      (repr (apply list name expected args) true))))
            (t.is result expected))
          (iter (cdr specs))))))

(define-macro (test-specs . body)
  "(test-specs . body)

   Macro that simplify calling %test-specs, Body need to be list
   of function calls where second argument is result the function.
   e.g.:

      (string=? #t \"foo\" \"bar\")  ;; this will fail"
  `(%test-specs t (list ,@(map (lambda (spec)
                                 `(list ,(symbol->string (car spec))
                                        ,@spec))
                               body))))
