  (fold-right / 1 (list 1 2 3))
  = (/ 1 (/ 2 (/ 3 1)))
  = (/ 1 2/3)
  = 3/2

  (fold-left / 1 (list 1 2 3))
  = (/ (/ (/ 1 1) 2) 3)
  = (/ (/ 1 2) 3)
  = (/ 1/2 3)
  = 1/6

  (fold-right list nil (list 1 2 3))
  = (list 1 (list 2 (list 3 nil)))
  = (1 (2 (3 ())))

  (fold-left list nil (list 1 2 3))
  = (list (list (list nil 1) 2) 3)
  = (((() 1) 2) 3)