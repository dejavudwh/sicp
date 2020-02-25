(define (make-account balance)
    
    (let ((id (generate-account-id)))                       ; +

        (define (withdraw amount)
            (if (>= balance amount)
                (begin (set! balance (- balance amount))
                       balance)
                "Insufficient funds"))

        (define (deposit amount)
            (set! balance (+ balance amount))
            balance)

        (let ((balance-serializer (make-serializer)))
            (define (dispatch m)
                (cond
                    ((eq? m 'withdraw)
                        withdraw)
                    ((eq? m 'deposit)
                        deposit)
                    ((eq? m 'balance)
                        balance)
                    ((eq? m 'serializer)
                        balance-serializer)
                    ((eq? m 'id)                            ; +
                        id)                                 ; +
                    (else
                        (error "Unknown request -- MAKE-ACCOUNT" m))))

            dispatch)))

(define (counter)
    (let ((i 0))
        (lambda ()
            (set! i (+ 1 i))
            i)))

(define generate-account-id (counter))


(define (serialized-exchange acc-1 acc-2)\
    (if (< (acc-1 'id) (acc-2 'id))
        (serialize-and-exchange acc-1 acc-2)
        (serialize-and-exchange acc-2 acc-1)))

(define (serialize-and-exchange smaller-id-account bigger-id-account)
    (let ((smaller-serializer (smaller-id-account 'serializer)))
        (let ((bigger-serializer (bigger-id-account 'serializer)))
            ((smaller-serializer (bigger-serializer exchange))
             smaller-id-account
             bigger-id-account))))