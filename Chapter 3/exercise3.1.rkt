(define (make-accumulator num)
  (lambda (x)
    (set! num (+ x num))
    (display num)
    (newline)))

(define a (make-accumulator 10))

(a 5)

(a 5)