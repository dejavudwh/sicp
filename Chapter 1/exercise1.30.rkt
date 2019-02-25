(define (itersum term a next b)
  (define (iter a result)
    (if (> a b)
        result
    (iter (next a) (+ result (term a)))))
  (iter a 0))

;;test
(define (pi-sum a b) 
 (define (pi-term x) 
         (/ 1.0 (* x (+ x 2)))) 
 (define (pi-next x) 
         (+ x 4))
 (itersum pi-term a pi-next b))

(* 8 (pi-sum 1 1000))  