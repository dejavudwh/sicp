(define (square x)
  (* x x))

(define (tree-map proc tree)
  (cond ((null? tree)
         '())
        ((not (pair? tree))
         (proc tree))
        (else
         (cons (tree-map proc (car tree))
               (tree-map proc (cdr tree))))))

(tree-map square (list (list 1 2) (list 3 4)))