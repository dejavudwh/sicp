((let? expr) (evaln (let->combination expr) env))

(define (let? expr) (tagged-list? expr 'let))
(define (let-vars expr) (map car (cadr expr)))
(define (let-inits expr) (map cadr (cadr expr)))
(define (let-body expr) (cddr expr))

(define (let->combination expr)
  (cons (make-lambda (let-vars expr) (let-body expr))
        (let-inits expr)))