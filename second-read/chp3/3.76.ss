#lang scheme

(define (smooth s1)
    (cons-stream (/ (+ (stream-car s1) (stream-cdr s2))
                    2)
                 (smooth (stream-cdr s1))))

(define (make-zero-crossings input-stream smooth)
    (define (iter s last-value)
        (cons-stream (sign-change-detecotr (stream-car s)
                                           last-value)
                     (iter (stream-cdr input-stream) (stream-car input-stream))))
    (iter (smooth input-stream) 0))
