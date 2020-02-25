#lang scheme

(define (pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
                  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t)))))


(define (triples s t u)
  (cons-stream (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map 
        (lambda (x) (cons (stream-car s) x))
        (pairs t (stream-cdr u)))
      (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define p (triples integers integers integers))

(define triangles
  (stream-filter
    (lambda (triple) (= (+ (square (car triple))
                           (square (cadr triple)))
                        (square (caddr triple))))
    p))