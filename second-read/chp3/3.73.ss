#lang scheme

(define (RC r c dt) 
    (define (proc i v) 
        (add-streams (scale-stream i r) 
                     (integral (scale-stream i (/ 1 c)) v dt))) 
    proc) 