(define (fringe tree)
  (define nil '())
  (if (null? tree)
      nil
      (let ((first (car tree)))
        (if (not (pair? first))
            (cons first (fringe (cdr tree)))
            (append (fringe first) (fringe (cdr tree)))))))

(define tree (list 1 (list 2 (list 3 4) (list 5 6)) (list 7 (list 8)))) 

(fringe tree)