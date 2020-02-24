#lang planet neil/sicp 

; constructor

(define (make-tree key value left-branch right-branch)
    (list key value left-branch right-branch))

; selector

(define (tree-key tree)
    (car tree))

(define (tree-value tree)
    (cadr tree))

(define (tree-left-branch tree)
    (caddr tree))

(define (tree-right-branch tree)
    (cadddr tree))

(define (tree-empty? tree)
    (null? tree))

; setter

(define (tree-set-key! new-key tree)
    (set-car! tree new-key))

(define (tree-set-value! new-value tree)
    (set-car! (cdr tree) new-value))

(define (tree-set-left-branch! new-left-branch tree)
    (set-car! (cddr tree) new-left-branch))

(define (tree-set-right-branch! new-right-branch tree)
    (set-car! (cdddr tree) new-right-branch))

; operator

(define (tree-insert! tree given-key value compare)
    (if (tree-empty? tree)
        (make-tree given-key value '() '())
        (let ((compare-result (compare given-key (tree-key tree))))
            (cond ((= 0 compare-result)
                    (tree-set-value! value tree)
                    tree)
                  ((= 1 compare-result)
                    (tree-set-right-branch!
                        (tree-insert! (tree-right-branch tree) given-key value compare)
                        tree)
                    tree)
                  ((= -1 compare-result)
                    (tree-set-left-branch!
                        (tree-insert! (tree-left-branch tree) given-key value compare)
                        tree)
                    tree)))))

(define (tree-search tree given-key compare)
    (if (tree-empty? tree)
        '()
        (let ((compare-result (compare given-key (tree-key tree))))
            (cond ((= 0 compare-result)
                    tree)
                  ((= 1 compare-result)
                    (tree-search (tree-right-branch tree) given-key compare))
                  ((= -1 compare-result)
                    (tree-search (tree-left-branch tree) given-key compare))))))

; comparer

(define (compare-string x y)
    (cond ((string=? x y)
            0)
          ((string>? x y)
            1)
          ((string<? x y)
            -1)))

(define (compare-symbol x y)
    (compare-string (symbol->string x)
                    (symbol->string y)))

(define (compare-number x y)
    (cond ((= x y)
            0)
          ((> x y)
            1)
          ((< x y)
            -1)))

(define (make-table compare)
    (let ((t '()))

        (define (empty?)
            (tree-empty? t))

        (define (insert! given-key value)
            (set! t (tree-insert! t given-key value compare))
            'ok)

        (define (lookup given-key)
            (let ((result (tree-search t given-key compare)))
                (if (null? result)
                    #f
                    (tree-value result))))

        (define (dispatch m)
            (cond ((eq? m 'insert!)
                    insert!)
                  ((eq? m 'lookup)
                    lookup)
                  ((eq? m 'empty?)
                    (empty?))
                  ((eq? m 'debug)
                    t)
                  (else
                    (error "Unknow mode " m))))

        dispatch))

(define (memoize f)
    (let ((table (make-table compare-number)))
        (lambda (x)
            (display (table 'debug))
            (newline)
            (let ((previously-computed-result ((table 'lookup) x)))
                (or previously-computed-result
                    (let ((result (f x)))
                        ((table 'insert!) x result)
                        result))))))

(define memo-fib
    (memoize (lambda (n)
                (cond ((= n 0) 0)
                      ((= n 1) 1)
                      (else (+ (memo-fib (- n 1))
                               (memo-fib (- n 2))))))))

(memo-fib 3)

; 其实这里有一个重要的点开始一直没有理解，memoize只调用了一个，因为memo-fib只是一个被返回回来的函数

; 直接用(memoize fib)肯定是不行的，因为运行第二次fib的时候只会从全局环境获得到这个函数，就失去了记忆功能