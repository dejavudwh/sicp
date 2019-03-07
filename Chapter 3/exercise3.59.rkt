(define (integrate-series a)
    (mul-streams a                                  
                 (div-streams ones integers)))

(define (div-streams s1 s2)
    (stream-map / s1 s2))