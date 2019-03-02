 (define (raise x) (apply-generic 'raise x)) 
  
 ;; 加入Scheme-number算术包
 (put 'raise 'integer  
          (lambda (x) (make-rational x 1))) 
  
 ;; 加入有理数算术包
 (put 'raise 'rational 
          (lambda (x) (make-real (/ (numer x) (denom x))))) 
  
 ;; 加入实数算术包
 (put 'raise 'real 
          (lambda (x) (make-from-real-imag x 0))) 
  