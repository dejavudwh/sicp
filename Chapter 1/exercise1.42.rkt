(define (compose f1 f2)
  (lambda (x)
    (f1 (f2 x))))