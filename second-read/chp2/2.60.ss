#lang scheme

(define (element-of-set? el set)
    (cond ((null? set)
            #f)
          ((equal? el (car set))
            #t)
          (else
            (element-of-set? el (cdr set)))))

(define (adjoin-set x set)
    (cons x set))

(define (union-set set1 set2)
    (define (iter set append-set)
        (cond ((null? append-set)
                set)
              (else
                (iter (append set (list (car append-set))) (cdr append-set)))))
    (iter set1 set2))

(define (intersection-set set another)
    (define (iter set result)
        (if (or (null? set) (null? another))
            (reverse result)
            (let ((current-element (car set))
                  (remain-element (cdr set)))
                (if (and (element-of-set? current-element another)
                         (not (element-of-set? current-element result)))
                    (iter remain-element
                          (cons current-element result))
                    (iter remain-element result)))))
    (iter set '()))

; 在复杂度方面，有重复元素集合的 adjoin-set 比无重复元素集合的 adjoin-set 要低一个量级

; 但是在有重复元素的集合进行 element-of-set? union-set intersection-set ，随着重复元素的增多，算法的效率会越来越低

; 因此，对于插入操作频繁的应用来说，可以使用有重复元素的集合，而对于频繁进行查找、交集、并集这三个操作的应用来说，使用无重复元素的集合比较好