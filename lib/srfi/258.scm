(define (string->uninterned-symbol string)
  "(string->uninterned-symbol string)

   Returns an uninterned symbol with a textual name given by string."
  (new lips.LSymbol string #f))

(define (symbol-interned? symbol)
  "(symbol-interned? symbol)

   Returns #t if symbol is an interned (ordinary) symbol, and #f
   if it is uninterned."
  (typecheck "symbol-interned?" symbol "symbol")
  (let ((copy (new lips.LSymbol symbol.__name__)))
    (eq? copy symbol)))

(define generate-uninterned-symbol gensym)
