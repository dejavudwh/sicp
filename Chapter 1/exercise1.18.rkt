(define (double x) (+ x x)) 
(define (halve x) (floor (/ x 2))) 
  
(define (* a b) 
  (define (iter m a b) 
    (cond ((= b 0) m) 
          ((even? b) (iter m (double a) (halve b))) 
          (else (iter (+ m a) a (- b 1))))) 
  (iter 0 a b))

(* 7 10) 