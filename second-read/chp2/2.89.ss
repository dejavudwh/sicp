#lang scheme

; 稠密多项式的表示方式

(define (first-term term-list) 
   (list (car term-list) (- (length term-list) 1))) 
 (define (adjoin-term term term-list) 
   (let ((exponent (order term)) 
         (len (length term-list))) 
     (define (iter-adjoin times terms) 
       (cond ((=zero? (coeff term)) 
              terms)) 
             ((= exponent times) 
              (cons (coeff term) terms)) 
             (else (iter-adjoin (+ times 1)  
                                (cons 0 terms)))) 
         (iter-adjoin len term-list))) 