 (define (let-args exp) (cadr exp)) 
 (define (let-body exp) (cddr exp)) 
 (define (make-let args body) (cons 'let (cons args body))) 
  
 (define (let*->nested-lets exp) 
   (define (reduce-let* args body) 
     (if (null? args) 
         (sequence->exp body) 
         (make-let (list (car args)) 
                   (list (reduce-let* (cdr args) body))))) 
   (reduce-let* (let-args exp) (let-body exp))) 
  