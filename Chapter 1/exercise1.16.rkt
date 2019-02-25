(define (square x) (* x x)) 

(define (fast-expt b n)
  (define (iter-expt a b n)
    (cond ((= n 0) a)
          ((even? n) (iter-expt a (square b) (/ n 2)))
          (else (iter-expt (* a b) b (- n 1)))))
  (iter-expt 1 2 10))

(fast-expt 2 4)