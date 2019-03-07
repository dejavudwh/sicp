(define (has-cycle? list)
  (define (iter pair repeat-list)
    (cond ((not (pair? pair)) #f)
          ((memq? pair repeat-list) #t)
          (else
           (iter (cdr pair) (cons pair repeat-list)))))
  (iter list '()))