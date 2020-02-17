#lang scheme

(define (fringe tree)
  (cond ((null? (cdr tree)) 
            (if (pair? (car tree))
                (fringe (car tree))
                tree))
        ((not (pair? (car tree))) 
            (cons (car tree) (fringe (cdr tree))))
        (else 
            (append (fringe (car tree))
                (fringe (cdr tree))))))

(define x (list (list 1 (list 8 9)) (list 3 4)))
(fringe (list x x))