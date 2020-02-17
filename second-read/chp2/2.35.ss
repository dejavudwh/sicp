#lang scheme

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence)))))

(define (count-leaves tree)
    (accumulate +
                0
                (map (lambda (sub-tree)
                         (if (pair? sub-tree)           
                             (count-leaves sub-tree)     
                             1))                        
                     tree)))

(define x (list (list 1 (list 8 9)) (list 3 4) (list 10 11 (list 12 13))))
(count-leaves (list x x))