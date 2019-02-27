(define nil '())

(define (deep-reverse items)
  (define (iter items result)
    (if (null? items)
        result
        (let ((first (car items)))
          (iter (cdr items)
                (cons (if (not (pair? first))
                          first
                          (deep-reverse first))
                      result)))))
  (iter items nil))

(define x (list (list 1 2) (list 3 4))) 

(deep-reverse x) 
          