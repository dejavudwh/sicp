#lang scheme

(define (analyze-let exp)
    (let ((var-exp-pair (cadr exp))          
          (body (caddr exp)))                            
        (let ((var-list (map car var-exp-pair))         
              (exp-list (map cadr var-exp-pair)))       
            (lambda (env) (make-procedure var-list (analyze-sequence exp-list) env)))))

(define (analyze-let exp)
  (analyze (let->lambda exp)))