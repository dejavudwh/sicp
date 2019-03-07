(define (ripple-carry-adder Ak Bk Sk C)
  (define (iter A B S c-in c-out)
    (if (null? A)
        S
        (begin (full-adder (car A) (car B)
                           c-in (car S) c-out)
               (iter (cdr A) (cdr B) (cdr S)
                     (c-out) (make-wire)))))
  (iter Ak Bk Ck (make-wire)))
             