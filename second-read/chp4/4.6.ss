#lang scheme

(define (let->lambda exp)
    (let ((var-exp-pair (cadr exp))          
          (body (caddr exp)))                            
        (let ((var-list (map car var-exp-pair))         
              (exp-list (map cadr var-exp-pair)))       
            (list (make-lambda var-list body) exp-list))))