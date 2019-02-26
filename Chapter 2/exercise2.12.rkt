(define (make-center-percent c pct)
  (let ((width (* c (/ pct 100))))
    (make-interval (- c width) (+ c width))))