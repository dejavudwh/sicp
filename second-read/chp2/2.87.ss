#lang scheme

(define (install-polynomial-package) 
...
 (define (=zero? poly) 
   (define (zero-terms? termlist) 
     (if (empty-termlist? termlist)
         true 
         (and (=zero? (coeff (first-term termlist))) 
              (zero-terms? (rest-terms termlist))))) 
   (zero-terms? (term-list poly))) 

(put '=zero '(polynomial) =zero?)
...
)