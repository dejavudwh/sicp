(define x (list 1 3 (list 5 7) 9))


(car (cdr (car (cdr (cdr x)))))

(car (car (list (list 7))))

(define y (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

(cadadr (cadadr (cadadr )))