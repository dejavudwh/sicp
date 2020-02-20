#lang scheme

(define (element-of-set? el set)
    (cond ((null? set)
            #f)
          ((equal? el (car set))
            #t)
          (else
            (element-of-set? el (cdr set)))))

(define (union-set set1 set2)
    (define (iter set append-set)
        (cond ((null? append-set)
                set)
              ((element-of-set? (car append-set) set)
                (iter set (cdr append-set)))
              (else
                (iter (append set (list (car append-set))) (cdr append-set)))))
    (iter set1 set2))

(union-set '(1 2 3) '(2 3 4 5 6))