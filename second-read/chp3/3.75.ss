#lang scheme

; 这里需要的应该是上一个值和当前值的平均值，而不是上一个平均值和当前值的平均值

(define (make-zero-crossings input-stream last-value last-avpt-value)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream
      (sign-change-detector last-avpt-value avpt)
      (make-zero-crossings (stream-cdr input-stream) (stream-car input-stream) avpt))))