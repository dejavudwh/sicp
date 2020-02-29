#lang scheme

; 就是拿到所有排列组合然后filter一下，permutations在第二章的时候有

(define (permutations s)
    (if (null? s)
        (list '())
        (flatmap (lambda (x)
                    (map (lambda (p) (cons x p))
                         (permutations (remove x s))))
                 s)))

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence)))))

(define (flatmap proc sequence)
    (accumulate append '() (map proc sequence)))

(define (remove item sequence)
    (filter (lambda (x)
                (not (= x item)))
            sequence))
 
(define (present-solution solution)
  (map list 
       '(baker cooper fletcher miller smith)
       solution))
 
(define (multiple-dwelling)
     
  (define (invalid-solution permutation)
    (let ((baker (first permutation))
          (cooper (second permutation))
          (fletcher (third permutation))
          (miller (fourth permutation))
          (smith (fifth permutation)))
      (and (not (= baker 5))
           (not (= cooper 1))
           (not (= fletcher 5))
           (not (= fletcher 1))
           (> miller cooper)
           (not (= (abs (- smith fletcher)) 1))
           (not (= (abs (- fletcher cooper)) 1)))))
   
  (map present-solution
       (filter invalid-solution
               (permutations (list 1 2 3 4 5)))))

(permutations (list 1 2 3))