#lang scheme

(define (yang-hui-rec row col)
    (cond ((or (= col 0) (= row col))
          1)
          (else (+ (yang-hui (- row 1) (- col 1)) 
                   (yang-hui (- row 1) col)))))

(yang-hui-rec 3 2)