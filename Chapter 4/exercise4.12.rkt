(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "too few argu" vars vals)
          (error "too many argu" vars vals))))

(define (lookup-binding-in-frame var frame)
  (cond ((null? frame) (cons false '()))
        ((eq? (car (car frame)) var)
         (cons true (cdr (car frame))))
        (else (look-bind-in-frame var (cdr frame)))))

(define (set-binding-in-frame var val frame)
  (cond ((null? frame) false)
        ((eq? (car (car frame)) var)
         (set-cdr! (car frame) val)
         true)
        (else (set-binding-in-frame var val (cdr frame)))))

(define (set-variable-value! var val env)
  (if (eq? env the-empty-environment)
      (error "unbound variable" var)
      (if (set-binding-in-frame var val (first-frame env))
          true
          (set-variable-value! var val (encloseing-environment env)))))

(define (lookup-variable-value var env)
  (if (eq? env the-empty-environment)
      (error "unbound variable" var))
  (let ((result (lookup-binding-in-frame var (first-frame env))))
    (if (car result)
        (cdr result)
        (looup-variable-value var (enclosing-environment env)))))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (if (set-binding-in-frame var val frame)
        true
        (set-car! env (cons (cons var val) frame)))))
    