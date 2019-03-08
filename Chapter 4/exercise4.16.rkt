;;a
(define (look-variable-value-4.16a var env)
  (define (evn-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-enviroment env)))
            ((eq? var (car vars)) (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "unbound variable" var)
        (let ((frame (fitst-frame env)))
          (scan (frame-variable frame)
                (frame-values frame)))))
  (let ((value (env-loop env)))
    (if (eq? value '*unassigned*)
        (error "unassigned var")
        value)))

         