#lang scheme

 (define (queens) 
   (let ((q1 (amb 1 2 3 4 5 6 7 8))) 
     (let ((q2 (amb 1 2 3 4 5 6 7 8))) 
       (require (safe? q2 2 (rows->poses (list q1)))) 
       (let ((q3 (amb 1 2 3 4 5 6 7 8))) 
         (require (safe? q3 3 (rows->poses (list q1 q2)))) 
         (let ((q4 (amb 1 2 3 4 5 6 7 8))) 
           (require (safe? q4 4 (rows->poses (list q1 q2 q3)))) 
           (let ((q5 (amb 1 2 3 4 5 6 7 8))) 
             (require (safe? q5 5 (rows->poses (list q1 q2 q3 q4)))) 
             (let ((q6 (amb 1 2 3 4 5 6 7 8))) 
               (require (safe? q6 6 (rows->poses (list q1 q2 q3 q4 q5)))) 
               (let ((q7 (amb 1 2 3 4 5 6 7 8))) 
                 (require (safe? q7 7 (rows->poses (list q1 q2 q3 q4 q5 q6)))) 
                 (let ((q8 (amb 1 2 3 4 5 6 7 8))) 
                   (require (safe? q8 8 (rows->poses (list q1 q2 q3 q4 q5 q6 q7)))) 
                   (rows->poses (list q1 q2 q3 q4 q5 q6 q7 q8))))))))))) 
  
 (define (and a b c d) 
   (cond ((not a) false) 
         ((not b) false) 
         ((not c) false) 
         ((not d) false) 
         (else true)))       
  
 (define (or a b) 
   (if a 
       true 
       b)) 
  
 (define (same-row? p1 p2) 
   (= (car p1) (car p2))) 
  
 (define (same-col? p1 p2) 
   (= (cdr p1) (cdr p2))) 
  
 (define (same-diag? p1 p2) 
   (let ((row1 (car p1)) 
         (col1 (cdr p1)) 
         (row2 (car p2)) 
         (col2 (cdr p2))) 
     (or (= (+ row1 col1) (+ row2 col2)) 
         (= (- row1 col1) (- row2 col2))))) 
  
 (define (safe? row col positions) 
   (define (safe-iter kp other-positions) 
     (if (null? other-positions) 
         true 
         (and (not (same-row? kp (car other-positions))) 
              (not (same-col? kp (car other-positions))) 
              (not (same-diag? kp (car other-positions))) 
              (safe-iter kp (cdr other-positions))))) 
   (safe-iter (cons row col) positions)) 
  
 (define (rows->poses rows) 
   (define count 0) 
   (map (lambda (row) 
          (begin (set! count (+ count 1)) 
                 (cons row count))) 
        rows)) 
  
 (queens) 