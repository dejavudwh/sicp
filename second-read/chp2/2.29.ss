#lang scheme

(define (make-mobile left right)
    (list left right))

(define (make-branch length structure)
    (list length structure))

(define left-branch car)
(define right-branch cadr)
(define branch-length car)
(define branch-structure cadr)

(define (total-weight m)
  (let ((lb (left-branch m))
        (rb (right-branch m)))
    (cond
      ((and (pair? (branch-structure lb)) (pair? (branch-structure rb)))
        (+ (total-weight (branch-structure lb))
           (total-weight (branch-structure rb))))
      ((and (pair? (branch-structure lb)) (not (pair? (branch-structure rb))))
        (+ (total-weight (branch-structure lb))
           (branch-structure rb)))
      ((and (not (pair? (branch-structure lb))) (pair? (branch-structure rb)))
        (+ (total-weight (branch-structure rb))
           (branch-structure lb)))
      (else
        (+ (branch-structure lb)
           (branch-structure rb))))))

(define (mobile-balanced? mobile)
    (define (mobile? s) (pair? s))
    (define (weight? s) 
        (and (not (mobile? s))
            (number? s)))
    (define (branch-torque branch)
        (* (branch-length branch) (branch-weight branch)))
    (define (branch-balanced? branch)
        (let ((structure (branch-structure branch)))
            (or (weight? structure)  
            (mobile-balanced? structure))))
    (define (branch-weight branch)
        (let ((structure (branch-structure branch)))
            (if (weight? structure) 
                structure
                (mobile-weight structure))))
    (define (mobile-weight mobile)
        (+ (branch-weight (left-branch  mobile)) 
           (branch-weight (right-branch mobile))))
    (let ((left  (left-branch  mobile))
          (right (right-branch mobile)))
        (and (branch-balanced? left)
             (branch-balanced? right)
             (= (branch-torque (left-branch  mobile))
                (branch-torque (right-branch mobile))))))

(define a (make-mobile (make-branch 2 3) (make-branch 2 3)))
(define b (make-mobile (make-branch 2 3) (make-branch 4 5)))
(total-weight a)
(total-weight b)

(define c (make-mobile (make-branch 5 a) (make-branch 3 b)))
(total-weight c)

(mobile-balanced? c)

(define d (make-mobile (make-branch 10 a) (make-branch 12 5)))
(mobile-balanced? d)

; d)小题这里只要修改选择函数就可以了，这也就是抽象的好处了
; (define left-branch car)
; (define right-branch cdr)
; (define branch-length car )
; (define branch-structure cdr)
