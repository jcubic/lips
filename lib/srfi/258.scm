(define (string->uninterned-symbol string)
  "(string->uninterned-symbol string)

   Returns an uninterned symbol with a textual name given by string."
  (new lips.LSymbol string #f))

(define (symbol-interned? symbol)
  "(symbol-interned? symbol)

   Returns #t if symbol is an interned (ordinary) symbol, and #f
   if it is uninterned."
  (typecheck "symbol-interned?" symbol "symbol")
  symbol.__interned__)

(define generate-uninterned-symbol
  (let ((count 0))
    (lambda args
      (let ((prefix (if (null? args)
                        ":"
                        (car args))))
        (typecheck "generate-uninterned-symbol" prefix "string")
        (let ((name (string-append prefix
                                   (number->string count))))
          (set! count (+ count 1))
          (lips.LSymbol name #f))))))

(set-special! ":|" '%uninterned-symbol)

(define (%uninterned-symbol symbol)
  `(quote ,(lips.LSymbol symbol.__name__ #f)))
