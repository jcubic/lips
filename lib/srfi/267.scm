(define (%read-raw . rest)
  "(%read-raw [port])

   Read a SRFI-267 raw string from the port, starting after the `#\"` prefix.

   The syntax is `#\"X\"S\"X\"`, where the delimiter X is any (possibly empty)
   sequence of characters that doesn't contain a double quote, and S is the
   content, taken verbatim - no escape sequences are interpreted. S ends at
   the first `\"X\"` that follows."
  (let ((port (if (null? rest) (current-input-port) (car rest))))
    (define (next)
      (let ((char (read-char port)))
        (if (eof-object? char)
            (error "Parse Error: unterminated raw string, expecting character #eof found")
            char)))
    ;; the delimiter can't contain a double quote, so the first one ends it
    (define delimiter
      (let loop ((chars '()))
        (let ((char (next)))
          (if (char=? char #\")
              (reverse chars)
              (loop (cons char chars))))))
    ;; `result` is the content collected so far, in reverse order
    (define (scan result)
      (let ((char (next)))
        (if (char=? char #\")
            (match result delimiter '())
            (scan (cons char result)))))
    ;; a `"` was read: it terminates the string if the delimiter and one more
    ;; `"` follow. `rest` is the delimiter left to match, `seen` the part of it
    ;; already matched (in reverse order)
    (define (match result rest seen)
      (let ((char (next)))
        (cond ((null? rest)
               (if (char=? char #\")
                   (list->string (reverse result))
                   (abandon result seen char)))
              ((char=? char (car rest))
               (match result (cdr rest) (cons char seen)))
              (else
               (abandon result seen char)))))
    ;; the candidate turned out to be content after all, so the `"` that opened
    ;; it and the delimiter prefix that did match are part of the string
    (define (abandon result seen char)
      (let ((result (append seen (cons #\" result))))
        (if (char=? char #\")
            ;; the delimiter can't contain a double quote, so this one can only
            ;; be the start of the next candidate terminator
            (match result delimiter '())
            (scan (cons char result)))))
    (scan '())))

(set-special! "#\"" %read-raw lips.specials.SYMBOL)
