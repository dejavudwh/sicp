#lang scheme

; 这里如果安装了Louis的强制过程就会导致apply-generic在遇到相同类型参数时陷入无限循环
; 因为每当找不到想应的通用操作时就会进行类型强制，但是Louis的强制过程之后还是相同的类型，所以会导致陷入无限循环

(define (apply-generic op . args)
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (if (= (length args) 2)
                    (let ((type1 (car type-tags))
                          (type2 (cadr type-tags))
                          (a1 (car args))
                          (a2 (cadr args)))
                        (if (equal? type1 type2)                                    
                            (error "No method for these types" (list op type-tags))  
                            (let ((t1->t2 (get-coercion type1 type2))
                                  (t2->t1 (get-coercion type2 type1)))
                                (cond (t1->t2
                                        (apply-generic op (t1->t2 a1) a2))
                                      (t2->t1
                                        (apply-generic op a1 (t2->t1 a2)))
                                      (else
                                        (error "No method for these types"
                                                (list op type-tags)))))))
                    (error "No method for these types"
                            (list op type-tags)))))))