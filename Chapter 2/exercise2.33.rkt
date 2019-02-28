(define (map proc sequence)
  (accumlate (lambda (x y)
               (cons (proc x) y))
             nil
             sequence))

(define (append list1 list2)
  (accumlate cons list2 list1))

(define (length proc sequence)
  (accumlate (lambda (x y)
               (+ 1 y))
             0
             sequence))