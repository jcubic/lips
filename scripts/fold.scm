#!/usr/bin/env lips

(define fs (require "node:fs/promises"))

(define (get-data)
  (let ((path (string-append __dirname "/../assets/CaseFolding.txt")))
    (fs.readFile path "utf8")))

(define (get-mapping data)
  ;; full case folding uses both the Common (C, single character) and Full
  ;; (F, multiple character - e.g. ß => "ss", İ => "i" + U+0307) mappings.
  (--> data
       (split "\n")
       (filter (lambda (line)
                  (and (not (string=? line ""))
                       (null? (line.match #/^#/))
                       (not (null? (line.match #/; [CF];/))))))
       (map (lambda (line)
              (let* ((parts (line.split "; "))
                     (orig (string->number (. parts 0) 16))
                     (folds (--> (. parts 2)
                                 (split " ")
                                 (map (lambda (h) (string->number h 16)))))
                     (value (if (= folds.length 1)
                                (number->string (. folds 0))
                                (string-append "[" (--> folds (join ", ")) "]"))))
                (string-append "\"" (number->string orig) "\"" ": " value))))))

(print (string-append "const fold_case_mapping = {"
                      (--> (get-mapping (get-data))
                           (reduce (lambda (acc expr index arr)
                                     (if (zero? index)
                                         (string-append "\n    " expr ", ")
                                         (let ((suffix (if (= (- arr.length 1) index) "" ", ")))
                                           (if (zero? (remainder index 4))
                                               (string-append acc "\n    " expr suffix)
                                               (string-append acc expr suffix)))))
                                         ""))
                      "\n}"))
