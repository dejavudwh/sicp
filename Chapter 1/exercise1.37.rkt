;; recursive
(define (cont-frac N D k)
  (define (recur i)
      (if (= k i)
          (/ (N k) (D k))
          (/ (N i)
             (+ (D i) (recur (+ i 1))))))
 (recur 1))

;;iterative

(define (cont-frac N D k)
    (define (iter i result)
        (if (= i 0)
            result
            (iter (- i 1)
                  (/ (N i)
                     (+ (D i) result)))))
    (iter (- k 1)
          (/ (N k) (D k))))