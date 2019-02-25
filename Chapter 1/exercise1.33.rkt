(define (filtered-accumulate combiner null-value term a next b filter)
  (if (> a b)
      null-value
      (if (filter a)
          (combiner (term a) (filtered-accumulate combiner null-value term (next a) next b filter)) 
          (combiner null-value (filtered-accumulate combiner null-value term (next a) next b filter)))))

;迭代版本

(define (filtered-accumulate combiner null-value term a next b filter) 
 (define (iter a result) 
   (cond ((> a b) result) 
      ((filter a) (iter (next a) (combiner result (term a)))) 
      (else (iter (next a) result)))) 
(iter a null-value)) 