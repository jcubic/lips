#!/usr/bin/env lips

(define fs (require "fs/promises"))

(define (load-docs)
  (let ((fname "./docs/reference.json"))
    (JSON.parse (fs.readFile fname "utf8"))))

(let ((docs (load-docs)))
  (print "# Function Reference")
  (print "")
  (docs.forEach (lambda (item)
                  (print (string-append "## " item.name))
                  (print "```")
                  (if (null? item.doc)
                      (print "TODO: missing docs")
                      (print item.doc))
                  (print "```")
                  (print ""))))
