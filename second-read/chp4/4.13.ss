#lang scheme

; 只删除当前框架里的约束

(define (make-unbound! var env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars) 'OK)
            ((eq? var (car vars))
              (set! vals (cdr vals))
              (set! vars (cdr vars)))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))