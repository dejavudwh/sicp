(define (spans-zero? interval)
  (and (>= (upper-bound interval) 0)
       (<= (lower-bound interval) 0)))
 
(define (div-interval x y)
  (if (spans-zero? y)
      (error "div-interval cannot divide by an interval that spans 0")
      (mul-interval x 
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))