 (define (div-interval x y) 
   (if (<= 0 (* (lower-bound y) (upper-bound y))) 
       (error "error (interval spans 0)") 
       (mul-interval x  
                     (make-interval (/ 1. (upper-bound y)) 
                                    (/ 1. (lower-bound y)))))) 