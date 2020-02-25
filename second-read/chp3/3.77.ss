#lang scheme

(define (integral2 delayed-integrand initial-value dt)
  (cons-stream initial-value
    (let ((integrand (force delayed-integrand)))
      (if (stream-null? integrand)
        the-empty-stream
        (integral2 (delay (stream-cdr integrand))
                    (+ (* dt (stream-car integrand))
                       initial-value)
                    dt)))))



(define (solve f y0 dt)
  (define y (integral2 (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)
