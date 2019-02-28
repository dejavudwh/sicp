 (define nil '()) 
  
 (define (subsets s) 
   (if (null? s) 
       (list nil)   
       (let ((rest (subsets (cdr s)))) 
         (append rest (map (lambda (x) (cons (car s) x)) rest))))) 
  


(define (print-list list)
  (cond ((null? list)
         '())
        ((display (car list))
         (print-list (cdr list)))))

(print-list (subsets (list 1 2 3)) )