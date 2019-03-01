(define (adjoin-set x set)
  (if (null? set)
      (list x)
      (let ((current (car set))
            (remain (cdr set)))
        (cond ((= x current)
              set)
              ((> x current)
               (cons
                current (adjoin-set x remain)))
              ((< x current)
               (cons x set))))))

(adjoin-set 3 (list 1 2 3)) 