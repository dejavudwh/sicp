#lang planet neil/sicp 

(define (last-pair x)
    (if (null? (cdr x))
        x
        (last-pair (cdr x))))

(define (contains-cycle? lst) 
   (let ((encountered (list))) 
     (define (loop lst) 
       (if (not (pair? lst)) 
           false 
           (if (memq lst encountered) 
               true 
               (begin (set! encountered (cons lst encountered)) 
                      (or (loop (car lst)) 
                          (loop (cdr lst))))))) 
     (loop lst))) 

(contains-cycle? (list 1 2 3))

(define loop-list (list 1 2 3))

(set-cdr! (last-pair loop-list) loop-list)

(contains-cycle? loop-list)