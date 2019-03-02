;;判断不为空即可

 (define (zero-poly? p) 
    (empty-termlist? (term-list p)))

(put '=zero? 'polynomial =zero?)