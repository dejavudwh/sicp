#lang scheme

(define (analyze-if-fail exp)
  (let ((pproc (analyze (if-predicate exp)))
         (cproc (analyze (if-consequent exp))))
    (lambda (env succeed fail)
      (pproc
        env
        succeed
        (lambda ()
          (cproc env succeed fail))))))
