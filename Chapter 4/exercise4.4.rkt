(define (and-clauses exp) (cdr exp))
(define (or-clauses exp) (cdr exp))
(define (first-exp seq) (car exp))
(define (rest-exp seq) (cdr seq))
(define (empty-exp? seq) (null? seq))
(define (last-exp seq) (null? (cdr exp)))

(define (eval-and exps env)
  (cond ((empty-exp? exps) #t)
        (else
         (let ((first (eval (first-expt exps) env)))
           (cond ((last-exp? exps) first)
                 (first (eval-and (rest-exp exps) env))
                 (else #f))))))

(define (eval-or exps env)
  (cond ((empty-exp? exps) #f)
        (else
         (let ((first (eval (first-exp exps) env)))
           (cond ((last-exp? exps) first)
                 (first #t)
                 (else
                  (eval-or (rest-exp exps) env)))))))

;;派生表达式
 (define (and->if exp) 
   (expand-and-clauses (and-clauses exp))) 
  
 (define (expand-and-clauses clauses) 
   (cond ((empty-exp? clauses) 'false) 
         ((last-exp? clauses) (first-exp clauses)) 
         (else (make-if (first-exp clauses) 
                        (expand-and-clauses (rest-exp clauses)) 
                        #f)))) 
  
 (define (or->if exp) 
   (expand-or-clauses (or-clauses exp))) 
  
 (define (expand-or-clauses clauses) 
   (cond ((empty-exp? clauses) 'false) 
         ((last-exp? clauses) (first-exp clauses)) 
         (else (make-if (first-exp clauses) 
                        #t 
                        (expand-or-clauses (rest-exp clauses)))))) 


