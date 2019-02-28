(define nil '())

(define (filter predicate sequence)
  (cond ((null? sequence)
         nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap proc sequence)
  (accumulate append nil (map proc sequence)))

(define (ordered-triples-sum n s)
  (filter (lambda (list) (= (accumulate + 0 list) s))
          (flatmap
           (lambda (i)
             (flatmap (lambda (j)
                        (map (lambda (k) (list i j k))
                               (enumerate-interval 1(- j 1))))
                        (enumerate-interval 1 (- i 1))))     
           (enumerate-interval 1 n))))

;;test
(ordered-triples-sum 10 12)