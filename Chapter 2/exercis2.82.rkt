(define (apply-generic op .args)
  (define (coerce-list-to-type lst type)
    (if (null? lst)
        '()
        (let ((t1->t2 (get-coercion (type-tag (car lst)) type)))
          (if t1->t2
              (cons (t1->t2 (car lst)) (coerce-list-to-type (cdr lst) type))
              (cons (car lst) (coerce-list-to-type (cdr lst) type))))))

  (define (apply-coerced lst)
    (if (null? lst)
        (error "No methos for given arguments")
        (let ((coerced-list (coerce-list-to-type arg (type-tag (car lst)))))
          (let ((proc (get op (map type-tag coerced-list))))
            (if proc
                (apply proc (map contents coerced-list))
                (apply-coerced (cdr lst)))))))


  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (apply-coerced args)))))