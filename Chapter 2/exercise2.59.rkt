(define (union-set set1 set2)
  (define (iter input result)
    (if (null? input)
        (reverse result)
        (let ((current (car input))
              (remain (cdr input)))
              (if (element-of-set? current result)
                  (iter remain result)
                  (iter remain
                        (cons current result))))))
  (iter (append set1 set2) '()))

(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((equal? x (car set))
         #t)
        (else
         (element-of-set? x (cdr set)))))

(union-set '(1 2 3) '(3 4 5 6))