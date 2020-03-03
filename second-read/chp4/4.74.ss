#lang scheme

;  a)

(define (simple-query-flatmap proc s)
  (simple-flatten (stream-map proc s)))

(define (simple-flatten stream)
  (stream-map stream-car
              (stream-filter (lambda (stream) (not (stream-null? stream)))
                             stream)))

; b)

; 不会