#lang scheme

(define (same-parity x . l)
    (let ((parity (even? x)))
        (define (iter-l parity t result)
            (cond ((null? t)
                    result)
                  ((not (xor parity (even? (car t))))
                    (iter-l parity (cdr t) (append result (list (car t)))))
                  (else 
                    (iter-l parity (cdr t) (append result (list))))))
        (iter-l parity l (list))))
    
(same-parity 1 3 5 7 8 10 18 16 13)
