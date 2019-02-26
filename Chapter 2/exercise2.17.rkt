(define (last-pair list)
  
  (cond ((null? list)
         (ERROR "empty list"))
      ((null? (cdr list))
              list)
       (else
        (last-pair (cdr list)))))

(last-pair (list 1 2 3 4))