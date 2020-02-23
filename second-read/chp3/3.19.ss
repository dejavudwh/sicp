#lang planet neil/sicp 

(define (last-pair x)
    (if (null? (cdr x))
        x
        (last-pair (cdr x))))

(define (contain-cycle? x)
    (define (walk lst step)
        (cond ((null? lst)
                '())
            ((= step 0)
                lst)
            (else
                (walk (cdr lst)
                      (- step 1)))))
    (define (loop? a b)
        (cond ((or (null? a) (null? b))
              #f)
              ((eq? a b)
              #t)
              (else
                (loop? (walk a 1) (walk b 2)))))
    (loop? (walk x 1) (walk x 2)))

(contain-cycle? (list 1 2 3))

;Value: #f

(define circular-list (list 1 2 3))

;Value: circular-list

(set-cdr! (last-pair circular-list) circular-list)

;Unspecified return value

(contain-cycle? circular-list)