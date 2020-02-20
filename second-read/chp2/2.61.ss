#lang scheme

(define (adjoin-set x set)
    (cond ((null? (cdr set))
            (append set (list x)))
          ((> (car set) x)
            (append (list x) set))
          (else
            (cons (car set) (adjoin-set x (cdr set))))))
    
(adjoin-set 3 '(1 2 4 5))