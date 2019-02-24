(define (MAX a b c)
  (cond
    ((and (>= a c) (>= b c)) (+ a b ))
    ((and (>= b a) (>= c a)) (+ b c ))
    ((and (>= a b) (>= c b)) (+ a c ))))

(MAX 1 2 3)
(MAX 8 9 1)