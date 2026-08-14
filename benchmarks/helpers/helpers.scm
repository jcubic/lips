(define Benchmark (require "benchmark"))


(define-macro (suite . body)
   "(suite (add name fn) ...)

    Runs a Benchmark.js suite. Each result is printed as a plain Benchmark.js
    line on stdout, e.g.

        name x 1,234 ops/sec ±0.74% (94 runs sampled)

    which is the format github-action-benchmark parses (tool: benchmarkjs).
    The interactive \"Fastest is\" summary is written to stderr so it does not
    pollute the machine-readable stdout. The suite runs synchronously so the
    process produces all output before it exits (needed under CI)."
   `(let ((suite (new Benchmark.Suite)))
      (--> suite ,@body
                 (on "cycle" (lambda (e)
                               (print (e.target.toString))))
                 (on "complete" (lambda (e)
                                  (try
                                    (console.error
                                     (string-append "Fastest is "
                                                    (repr (--> (this.filter "fastest")
                                                               (map "name")
                                                               0))))
                                    (catch (e)
                                      (console.error e)))))
                 (run &(:async #f)))))
