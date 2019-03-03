(define (walk-list step list)
  (cond ((null? list)
         '())
        ((= step 0)
         list)
        (else
         (walk-list (- step 1)
                    (cdr list)))))

(define (fast-slow-walk list)
  (define (iter x y)
    (let ((x-walk (walk-list 1 x))
          (y-walk (walk-list 2 y)))
          (cond ((or (null? x-walk) (null? y-walk))
                 #f)
                ((eq? x-walk y-walk)
                 #t)
                (else
                 (iter x-walk y-walk)))))
  (iter list list))
         
    