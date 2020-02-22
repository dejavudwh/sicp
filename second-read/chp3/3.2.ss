#lang scheme

(define (make-monitored f)
    (let ((times 0))
        (define (dispatch m)
            (cond ((eq? m 'how-many-calls?)
                   times)
                  ((eq? m 'reset-count)
                   (set! times 0))
                  (else
                    (begin (+ times 1)
                           (f m)))))
    dispatch))

(define s (make-monitored sqrt))

(s 100)

(s 'how-many-calls?)