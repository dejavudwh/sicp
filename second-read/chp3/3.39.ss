#lang scheme

(parallel-execute (lambda () (set! x p1))
                  p2)

(set! x (+ 10 1)) => x = 11 => (set! x (* 11 11)) => x = 121
(set! x ?) => (set! x (+ 10 1)) => x = 11 => (set! x (* 11 11)) => x = 121
(set! x (* 10 10)) => x = 100 => (set! x (+ 100 1)) => x = 101

(set! x 
        -> p2
              -> (set! x p1)    ; 121

p2 -> (set! x) -> p1    ; 121

(set! x p1) -> p2   ;101