(define (element-of-set? x set)
    (cond ((null? set)
            #f)
          ((equal? x (car set))
            #t)
          (else
            (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
    (cons x set))

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

(define (intersection-set set another)
    (define (iter set result)
        (if (or (null? set) (null? another))
            (reverse result)
            (let ((current-element (car set))
                  (remain-element (cdr set)))
                (if (and (element-of-set? current-element another)
                         (not (element-of-set? current-element result)))
                    (iter remain-element
                          (cons current-element result))
                    (iter remain-element result)))))
    (iter set '()))