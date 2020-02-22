#lang scheme

(put 'negate 'scheme-number 
    (lambda (n) (tag (- n)))) 

(put 'negate 'rational 
    (lambda (rat) (make-rational (- (numer rat)) (denom rat)))) 

(put 'negate 'complex 
    (lambda (z) (make-from-real-imag (- (real-part z)) 
                                    (- (imag-part z))))) 

(define (negate-terms termlist) 
(if (empty-termlist? termlist) 
    the-empty-termlist 
    (let ((t (first-term termlist))) 
    (adjoin-term (make-term (order t) (negate (coeff t))) 
                (negate-terms (rest-terms termlist)))))) 

(put 'negate 'polynomial 
        (lambda (poly) (make-polynomial (variable poly) 
                                        (negate-terms (term-list poly))))) 
(put 'sub '(polynomial polynomial) 
    (lambda (x y) (tag (add-poly x (negate y))))) 