#lang scheme

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence)))))

(define (enumerate-interval start end)
    (if (> start end)
        '()
        (cons start (enumerate-interval (+ 1 start) end))))

(define (flatmap proc sequence)
    (accumulate append '() (map proc sequence)))

(define (unique-pairs n)
    (accumulate append
            '()
            (map (lambda (i)
                     (map (lambda (j) (list i j))
                          (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 n))))

(define (triples n)
    (flatmap (lambda (k)
                (map (lambda (p)
                        (cons k p))
                     (unique-pairs (- k 1))))
             (enumerate-interval 1 n)))

(define (triple-sum-equal? sum triple)
    (= sum
       (+ (car triple)
          (cadr triple)
          (caddr triple))))

(define (filter-triples sum triple)
    (filter (lambda (t)
                (triple-sum-equal? sum t))
            triple))

(define (unique-triple sum n)
    (filter-triples sum (triples n)))

(unique-triple 6 6)