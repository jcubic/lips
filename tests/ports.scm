(test "ports: scheme repr using output-string"
      (lambda (t)
        (define (repr x . rest)
          (let ((port (open-output-string))
                (quote (if (null? rest) #f (car rest))))
            (if quote
                (write x port)
                (display x port))
            (get-output-string port)))

        (t.is (repr '(1 2 3)) "(1 2 3)")
        (t.is (repr '#(1 2 (3 4))) "#(1 2 (3 4))")
        (t.is (repr '(1 2 "foo")) "(1 2 foo)")
        (t.is (repr '(1 2 "foo") true) "(1 2 \"foo\")")))

(test "ports: input-string"
      (lambda (t)
        (let ((p (open-input-string "xy")))
          (t.is (list (peek-char p)
                      (read-char p)
                      (peek-char p)
                      (read-char p)
                      (peek-char p)
                      (read-char p))
                (list #\x #\x #\y #\y lips.eof lips.eof)))
        (let ((result (vector))
              (p (open-input-string "first line
                                     second line")))
          (result.push (read-line p))
          (result.push (read-line p))
          (t.is result #("first line" "second line")))
        (let* ((input '(hello))
               (p (open-input-string (repr input))))
          (t.is (read p) input)
          (t.is (map eof-object? (list (read p) (read-char p) (read-line p)))
                '(true true true)))))

(test "ports: port repr"
      (lambda (t)
        (t.is (repr (current-input-port)) "#<input-port>")
        (t.is (repr (open-input-string "xxx")) "#<input-port (string)>")
        (t.is (repr (open-input-string "xxx")) "#<input-port (string)>")
        (t.is (repr (open-input-file "./tests/ports.scm"))
              "#<input-port (./tests/ports.scm)>")
        (t.is (repr (open-binary-input-file "./tests/ports.scm"))
              "#<input-binary-port (./tests/ports.scm)>")
        (t.is (repr (open-input-bytevector #u8(10)))
              "#<input-port (bytevector)>")))

(test "ports: syntax extensions"
      (lambda (t)
        (let ((p (open-input-string "#(1 2 3)")))
          (t.is (read p) #(1 2 3)))))

(test "ports: input-port"
      (lambda (t)
        (let ((port (let* ((lines #("First Line" "Second Line" "Third Line"))
                           (i 0))
                      (lips.InputPort (lambda ()
                                        (if (>= i (vector-length lines))
                                            lips.eof
                                            (let ((line (vector-ref lines i)))
                                              (set! i (+ i 1))
                                              line)))))))
          (t.is (read-line port) "First Line")
          (t.is (read-line port) "Second Line")
          (t.is (read port) 'Third)
          (t.is (peek-char port) #\L)
          (t.is (read-char port) #\L)
          (t.is (read-char port) #\i)
          (t.is (read port) 'ne))))

(test "ports: read input file"
      (lambda (t)
        (define f (open-input-file "./tests/stubs/test.txt"))
        (let ((line (read-line f)))
          (t.is line "Hello this is File"))))

(test "ports: read after port close should throw"
      (lambda (t)
        (define f (open-input-file "./tests/ports.scm"))
        (read f)
        (close-input-port f)
        (t.is (repr (open-input-file "./tests/ports.scm"))
              "#<input-port (./tests/ports.scm)>")
        (t.is (to.throw (read f)) true)))

(test "ports: with-input-from-file"
      (lambda (t)
        (define stdin (current-input-port))
        (t.is (with-input-from-file "./tests/stubs/test.txt" read-line)
              "Hello this is File")
        (t.is (current-input-port) stdin)))

(test "ports: read/write/delete file"
      (lambda (t)
        (let ((filename "./tests/__x1__.scm"))
          (if (file-exists? filename)
              (delete-file filename))
          (let ((input '(hello world))
                (p (open-output-file filename))
                (result #f))
            (write input p)
            (close-output-port p)
            (let ((p (open-input-file filename)))
              (set! result (read p))
              (delete-file filename)
              (t.is result input))))))

(test "ports: write-char to output string"
      (lambda (t)
        (let ((input "(hello world)")
              (port (open-output-string)))
          (for-each (lambda (char)
                      (write-char char port))
                    (string->list (repr input)))
          (t.is (get-output-string port) input))))

(test "ports: write-char to output file"
      (lambda (t)
        (let ((filename "./tests/__x2__.scm"))
          (if (file-exists? filename)
              (delete-file filename))
          (let ((input '(hello world))
                (p (open-output-file filename))
                (result #f))
            (for-each (lambda (char)
                        (write-char char p))
                      (string->list (repr input)))
            (close-output-port p)
            (let ((p (open-input-file filename)))
              (set! result (read p))
              (delete-file filename)
              (t.is result input))))))

(test "ports: call-with-?-ports"
      (lambda (t)
        (let ((filename "./tests/__x3__.scm")
              (input '(hello world)))
          (if (file-exists? filename)
              (delete-file filename))
          (call-with-output-file filename (lambda (p) (write '(hello world) p)))
          (let ((result (call-with-input-file filename read)))
            (delete-file filename)
            (t.is result input)))))

(test "ports: close-output-port for output-string"
      (lambda (t)
        (let ((input '(hello)))
          (let ((p (open-output-string)))
            (write input p)
            (t.is (output-port-open? p) true)
            (close-output-port p)
            (t.is (to.throw (write "x" p)) true)
            (t.is (output-port-open? p) false)
            (t.is (get-output-string p) (repr input))))))

(test "ports: close-output-port for output-file"
      (lambda (t)
        (let ((input '(hello)))
          (let ((filename "./tests/__x4__.scm"))
            (if (file-exists? filename)
                (delete-file filename))
            (let ((p (open-output-file filename)))
              (write input p)
              (t.is (output-port-open? p) true)
              (close-output-port p)
              (t.is (to.throw (write "x" p)) true)
              (t.is (output-port-open? p) false)
              (let ((output (with-input-from-file filename read)))
                (t.is output input))
              (delete-file filename))))))


(test "ports: close-input-port for input-string"
      (lambda (t)
        (let* ((input '(hello))
               (port (open-input-string (repr input))))
          (t.is (read port) input)
          (t.is (input-port-open? port) true)
          (close-input-port port)
          (t.is (to.throw (read port)) true)
          (t.is (input-port-open? port) false))))

(test "ports: close-input-port for input-file"
      (lambda (t)
        (let* ((input '(hello))
               (filename "./tests/__x5__.scm"))
          (if (not (file-exists? filename))
              (with-output-to-file filename (curry write input)))
          (let ((port (open-input-file filename)))
            (t.is (read port) input)
            (t.is (input-port-open? port) true)
            (close-input-port port)
            (t.is (to.throw (read port)) true)
            (t.is (input-port-open? port) false)
            (delete-file filename)))))

(test "ports: read-string for input-string"
      (lambda (t)
        (let ((p (open-input-string "123456")))
          (t.is (list (read-string 2 p) (read-string 2 p) (read-string 10 p))
                '("12" "34" "56")))))

(test "ports: open-input-bytevector"
      (lambda (t)
        (let ((p (open-input-bytevector #u8(#x10 #x20 #xFF #xFF #xFF))))
          (t.is (binary-port? p) true)
          (t.is (textual-port? p) false)
          (close-input-port p))))

(test "ports: should close input-bytevector"
      (lambda (t)
        (let ((p (open-input-bytevector #u8(#x10 #x20 #xFF #xFF #xFF))))
          (close-input-port p)
          (t.is (to.throw (read-u8 p)) #t)
          (t.is (char-ready? p) #f)
          (t.is (u8-ready? p) #f))))

(test "ports: should return max elements from byte vector port"
      (lambda (t)
        (let ((port (open-input-bytevector #u8(#x10 #x20 #xFF #xFF #xFF))))
          (t.is (read-u8 port) #x10)
          (t.is (read-bytevector 100 port) #u8(#x20 #xFF #xFF #xFF))
          (close-port port))))

(test "ports: should read all elements from u8 byte vector port"
      (lambda (t)
        (let ((port (open-input-bytevector #u8(#x10 #x20 #xFF #xFF #xFF))))
          (t.is (with-input-from-port port read-bytevector) #u8(#x10 #x20 #xFF #xFF #xFF)))))

(test "ports: read from open-input-bytevector"
      (lambda (t)
        (let ((p (open-input-bytevector #u8(#x10 #x20 #xFF #xFF #xFF))))
          (t.is (peek-u8 p) #x10)
          (t.is (read-u8 p) #x10)
          (t.is (peek-u8 p) #x20)
          (t.is (peek-u8 p) #x20)
          (t.is (peek-u8 p) #x20)
          (let ((result (vector)))
            (while (not (eof-object? (peek-u8 p)))
              (result.push (read-u8 p)))
            (t.is result #(#x20 #xFF #xFF #xFF))
            (t.is (eof-object? (peek-u8 p)) true)
            (t.is (eof-object? (read-u8 p)) true)))))

(test "ports: textual-port?"
      (lambda (t)
        (let ((filename "./tests/__x6__.scm"))
          (if (file-exists? filename)
              (delete-file filename))
          (let* ((closable (list (open-input-file "./tests/ports.scm")
                                 (open-input-string "xxx")
                                 (open-output-string)
                                 (open-output-file filename)))
                 (ports (append (list (current-input-port)
                                      (current-output-port))
                                closable)))
            (for-each (lambda (p)
                        (t.is (textual-port? p) true))
                      ports)
            (for-each close-port closable)
            (delete-file filename)))))

(test "ports: read binary"
      (lambda (t)
        (let* ((fname "./tests/stubs/test.txt")
               (p (open-binary-input-file fname))
               (result (vector))
               (fs (require "fs")))
          (while (not (eof-object? (peek-u8 p)))
            (result.push (string (integer->char (read-u8 p)))))
          (t.is (result.join "") (--> (fs.promises.readFile fname)
                                      (toString))))))

(test "ports: read bytevector"
      (lambda (t)
        (let ((p (open-binary-input-file "./tests/stubs/test.txt")))
          (t.is (utf8->string (read-bytevector 10 p))
                "Hello this"))))

(test "ports: binary output port"
      (lambda (t)
        (let ((port (open-output-bytevector))
              (v (string->utf8 "hello")))
          (for-each (lambda (byte)
                      (write-u8 byte port))
                    (u8vector->list v))
          (write-u8 (char->integer #\space) port)
          (write-bytevector (string->utf8 "world") port)
          (let ((u8 (get-output-bytevector port)))
            (t.is (utf8->string u8) "hello world"))
          (close-port port)
          (t.is (to.throw (write-u8 (char->integer #\!) port))
                true)
          (t.is (to.throw (get-output-bytevector port))
                true))))

(test "ports: output binary file port"
      (lambda (t)
        (let ((fname "./tests/__x7__.scm")
              (str "hello, world!\n"))
          (if (file-exists? fname)
              (delete-file fname))
          (let ((port (open-binary-output-file fname)))
            (call-with-port port
                            (lambda (p)
                              (write-bytevector (string->utf8 str) p)))
            (t.is (to.throw (write-u8 10 port))
                  true)
            (t.is (with-input-from-file fname
                    (lambda ()
                      (let loop ((c (read-char)) (a '()))
                        (if (eof-object? c)
                            (list->string (reverse a))
                            (loop (read-char) (cons c a))))))
                  str)
            (delete-file fname)))))
