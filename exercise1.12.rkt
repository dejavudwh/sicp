(define (pascal r c) 
  (if (or (= c 1) (= c r)) 
      1 
      (+ (pascal (- r 1) (- c 1)) (pascal (- r 1) c)))) 
  

(pascal 2 2) 

  