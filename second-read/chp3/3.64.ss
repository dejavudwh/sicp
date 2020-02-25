#lang scheme

(define (stream-limit stream limit)
    (let ((ref-n (stream-car stream))
          (ref-n+1 (stream-car (stream-cdr stream))))
        (if (close-enough? ref-n ref-n+1 limit)
            ref-n+1
            (stream-limit (stream-cdr stream) limit))))

(define (close-enough? x y tolerance)
    (< (abs (- x y))
       tolerance))