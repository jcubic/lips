(define (frob filename)
  (call-with-input-file filename
    (lambda (port)
      (read port))))a

(set-special! "#:" frob lips.specials.LITERAL)

#:"data.scm"

(print x)
