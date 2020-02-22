#lang scheme

;;a 
(define (reduce-terms n d) 
    (let ((gcdterms (gcd-terms n d))) 
            (list (car (div-terms n gcdterms)) 
                (car (div-terms d gcdterms))))) 

(define (reduce-poly p1 p2) 
    (if (same-variable? (variable p1) (variable p2)) 
        (let ((result (reduce-terms (term-list p1) (term-list p2)))) 
            (list (make-poly (variable p1) (car result)) 
                    (make-poly (variable p1) (cadr result)))) 
        (error "not the same variable--REDUCE-POLY" (list p1 p2)))) 

;;b

(define (reduce x y) (apply-generic 'reduce x y))

(put 'reduce '(polynomial polynomial) (lambda (p1 p2) (reduce-poly p1 p2)))
 
(put 'reduce '(dense dense)  (lambda (t1 t2) (map tag (reduce-terms t1 t2))))
(put 'reduce '(dense sparse) (lambda (t1 t2) (map tag (reduce-terms t1 (sparse->dense t2)))))
 
(put 'reduce '(sparse sparse) (lambda (t1 t2) (map tag (reduce-terms t1 t2))))
(put 'reduce '(sparse dense)  (lambda (t1 t2) (map tag (reduce-terms t1 (dense->sparse t2)))))
 
(define (reduce-integers n d)
  (let ((g (gcd n d)))
    (list (/ n g) (/ d g))))  
 
(put 'reduce '(integer integer) (lambda (x y) (map tag (reduce-integers x y))))

