#lang scheme

; 我觉得能够影响找到答案的速度
; 如果把约束更加严格的条件放在前面，就能更快的排除更多选择

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require distinct? (list baker cooper fletcher miller smith))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (> miller cooper))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))