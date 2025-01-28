(test "TCO: it should calculate sum of 2000 integers"
       (lambda (t)
         (define (sum n)
           (let loop ((n n) (acc 0))
             (if (<= n 0)
                 acc
                 (loop (- n 1) (+ acc n)))))
         (let ((n 2000))
           (t.is (sum n) (apply + (range (+ n 1)))))))
