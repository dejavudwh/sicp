(define (product term a next b) 
  (if (> a b) 1 
     (* (term a) (product term (next a) next b))))

(define (iter-product term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (identity x) x) 
  
(define (next x) (+ x 1)) 
  
(define (factorial n) 
 (iter-product identity 1 next n))

;;test factorial
(factorial 5)

;;test pi
(define (pi-term n)
  (if (even? n)
      (/ (+ n 2) (+ n 1))
         (/ (+ n 1) (+ n 2))))

(* (iter-product pi-term 1 next 6) 4)