 (define (first-term term-list) 
     (make-term (- (len term-list) 1) (car term-list))) 
  
 (define (adjoin-term term term-list) 
   (cond ((=zero? term) term-list) 
         ((=equ? (order term) (length term-list)) (cons (coeff term) term-list)) 
         (else (adjoin-term term (cons 0 term-list))))) 