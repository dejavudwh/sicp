#lang scheme

(define (cc amount coin-values)
  (cond
    ((= amount 0) 1)
    ((or (no-more? coin-values) (< amount 0)) 0)
    (else
      (+ (cc (- amount (first-denomination coin-values)) coin-values)
         (cc amount (except-first-denomination coin-values))))))

(define (no-more? coin-values)
  (null? coin-values))
(define (first-denomination coin-values)
  (car coin-values))
(define (except-first-denomination coin-values)
  (cdr coin-values))


(define (start-test coins)
  (let ((s (runtime)))
    (cc 400 coins)
    (newline)
    (display (- (runtime) s))
    (newline)))