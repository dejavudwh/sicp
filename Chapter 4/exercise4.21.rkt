 ((lambda (n) 
    ((lambda (fib) 
       (fib fib 1 0 n)) 
     (lambda (fib a b count) 
       (if (= count 0) 
           b 
           (fib fib (+ a b) a (- count 1)))))) 
  10)

;;b
 ev? od? (- n 1) 
 ev? od? (- n 1) 