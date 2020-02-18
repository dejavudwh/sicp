#lang scheme

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap proc sequence)
  (accumulate append '() (map proc sequence)))

(define (adjoin-position new-row rest-of-queens)
  (cons new-row rest-of-queens))

(define empty-board '())

(define (safe? k position)
  (define (iter new-queen rest-queens i)
    (if (null? rest-queens)
        #t
        (let ((queen (car rest-queens)))
          (if (or (= new-queen queen)
                  (= new-queen (+ i queen))
                  (= new-queen (- queen i)))
              #f
              (iter new-queen (cdr rest-queens) (+ i 1))))))
  (iter (car position) (cdr position) 1))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
           (lambda (position) (safe? k position))
           (flatmap
              (lambda (rest-of-queens)
              (map (lambda (new-row)
                   (adjoin-position new-row rest-of-queens))
                 (enumerate-interval 1 board-size)))
           (queen-cols (- k 1))))))
  (queen-cols board-size))

(for-each (lambda (pos)
                    (begin
                        (display pos)
                        (newline)))
                (queens 8))
            