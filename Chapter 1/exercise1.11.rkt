;;递归版
(define (f n) 
   (cond ((< n 3)
          n) 
        (else (+ (f (- n 1)) 
                 (* 2 (f (- n 2)))
                 (* 3 (f (- n 3)))))))

;;迭代版
;; f(0) = 0 f(1) = 1 f(2) = 2

(define (f n)
  (define (iter-f a b c i n)
    (cond ((= i (- n 2))
           a)
          (else (iter-f (+ a (* 2 b) (* 3 c))
                        a
                        b
                        (+ i 1)
                        n))))
  (iter-f 2 1 0 0 n))

(f 5)