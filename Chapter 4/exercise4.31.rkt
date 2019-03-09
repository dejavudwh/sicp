 (define (apply procedure arguments env) 
     (cond 
         ((primitive-procedure? procedure) 
             (apply-primitive-procedure 
                 procedure 
                 (list-of-arg-values arguments env))) 
         ((compound-procedure? procedure) 
             (eval-compound-procedure procedure arguments env)) 
         (else 
             (error "Unknown procedure type -- APPLY" procedure)))) 
  
 (define (eval-compound-procedure procedure arguments env) 
     (define (iter-args formal-args actual-args) 
         (if (null? formal-args) 
             '() 
             (cons 
                 (let ((this-arg (car formal-args))) 
                     (if (and (pair? this-arg) 
                              (pair? (cdr this-arg)) ; avoid error if arg is  
                                                     ; 1 element list. 
                              (eq? (cadr this-arg) 'lazy)) 
                         (delay-it (car actual-args) env) 
                          ;force the argument if it is not lazy.  
                         (actual-value (car actual-args) env))) 
                 (iter-args (cdr formal-args) (cdr actual-args))))) 
  
     (define (procedure-arg-names parameters) 
         (map (lambda (x) (if (pair? x) (car x) x)) parameters)) 
  
     (eval-sequence 
         (procedure-body procedure) 
         (extend-environment 
             (procedure-arg-names (procedure-parameters procedure)) 
             (iter-args  
                 (procedure-parameters procedure) 
                 arguments) 
             (procedure-environment procedure)))) 
  
 (driver-loop) 