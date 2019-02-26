(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (make-segment bottom-left top-right) (cons bottom-left top-right))
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))

(define (print-point p) 
   (newline) 
   (display "(") 
   (display (x-point p)) 
   (display ",") 
   (display (y-point p)) 
   (display ")")) 

(define (midpoint-segment segment)
 
  (make-point (/ (+ (x-point (start-segment segment)) (x-point(end-segment segment))
                 2))
              (/ (+ (y-point(start-segment segment)) (y-point (end-segment segment))
                 2))))

 ;; Testing 
 (define seg (make-segment (make-point 2 3) 
                           (make-point 10 15))) 
  
 (print-point (midpoint-segment seg)) 