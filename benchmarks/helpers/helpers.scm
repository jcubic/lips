(define Benchmark (require "benchmark"))

;; A fixed, interpreter-bound workload used to NORMALISE every benchmark to the
;; runner's current speed. CI runners differ in CPU (and are noisy shared VMs),
;; so absolute ops/sec are not comparable across runs; dividing each result by
;; the calibration measured in the SAME run cancels the machine-speed factor out
;; and leaves a metric that only moves when the interpreter itself changes.
;; Keep this workload STABLE across commits - changing it rebases every tracked
;; number.
(define (%benchmark-calibration)
  (let loop ((i 0) (acc 0))
    (if (= i 3000)
        acc
        (loop (+ i 1) (modulo (+ (* acc 31) i) 1000003)))))

(define (%round2 x)
  ;; round to 2 decimals AND return an inexact (decimal) number - github-action
  ;; -benchmark's benchmarkjs parser needs "30033.93", not the exact rational
  ;; 3003393/100 that lips `/` would otherwise produce
  (/ (Math.round (* x 100)) 100.0))

(define-macro (suite . body)
   "(suite (add name fn) ...)

    Runs a Benchmark.js suite. A calibration workload is run first and every
    other result is printed RELATIVE to it - its ops/sec divided by the
    calibration's (scaled by 1000) - so the tracked number is independent of
    which CI runner the job landed on. Each line still uses the Benchmark.js
    format github-action-benchmark parses (tool: benchmarkjs):

        name x 1234.5 ops/sec ±0.74% (94 runs sampled)

    where the value is `name-hz / calibration-hz * 1000` (a unitless ratio, not
    real ops/sec). The calibration's own raw speed is written to stderr so
    machine variance stays visible but untracked, together with the interactive
    \"Fastest is\" summary. The suite runs synchronously so the process produces
    all output before it exits (needed under CI)."
   `(let ((suite (new Benchmark.Suite))
          (calibration #f))
      (--> suite
           (add "calibration" %benchmark-calibration)
           ,@body
           (on "cycle" (lambda (e)
                         (let ((t e.target))
                           (if (string=? t.name "calibration")
                               (begin
                                 ;; first cycle: record the machine baseline
                                 (set! calibration t.hz)
                                 (console.error (string-append "calibration: "
                                                               (number->string (%round2 t.hz))
                                                               " ops/sec (machine baseline, untracked)")))
                               ;; every real benchmark, reported relative to it
                               (let ((value (if calibration
                                                (%round2 (* (/ t.hz calibration) 1000))
                                                t.hz)))
                                 (print (string-append t.name
                                                       " x " (number->string value)
                                                       " ops/sec ±" (number->string (%round2 t.stats.rme))
                                                       "% (" (number->string t.stats.sample.length)
                                                       " runs sampled)")))))))
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
