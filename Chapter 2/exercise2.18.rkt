(define (reverse list)
  (define (iter list result)
    (if (null? list)
        result
    (iter (cdr list) (cons (car list) result))))
  (iter list nil))
 
(reverse (list 1 2 3 4))