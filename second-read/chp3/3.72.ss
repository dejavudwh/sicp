#lang scheme
  
(define (weight i j)
  (+ (square i) (square j)))

(define p (weighted-pairs integers integers weight))

(define (pair-weigth p)
  (weight (car p) (cdr p)))

(define (generate-num-seq pairs)
  (let ((first (stream-car pairs))
        (second (stream-car (stream-cdr pairs)))
        (third (stream-car (stream-cdr (stream-cdr pairs)))))
    (if (= (pair-weigth first) (pair-weigth second) (pair-weigth third))
        (begin
            (cons-stream (pair-weigth first)
            (generate-num-seq (stream-cdr pairs))))
        (generate-num-seq (stream-cdr pairs)))))

(define num-seq (generate-num-seq p))