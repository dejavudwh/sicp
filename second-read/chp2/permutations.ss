#lang scheme

; permutations和subsets这两个过程非常有助于理解递归思想
; 首先理解递归的过程的关键点在于理解它的计算过程产生的形状和最后的基准情况，以及理解分解问题，减小问题的规模
;
; 比如subsets的功能是找出所有子集，例(list 1 2 3)
; 它的基准情况就是空集'()
; 分解问题就是在于当前集合的子集会等于少去一个元素集合的子集加上对遍历这个子集并上少去的这个元素
; 这个过程的形状就在于rest，rest的规模会越来越少，然后到达基准情况开始返回，然后对返回的结果进行上面的操作
; 所以写出这个过程的关键在于如何减小问题的规模，和分解问题上最后结果的合并（形状）上

; permutations是对当前集合进行排列组合，会更加复杂一点，但是方法还是和之前的相同
; 首先是分解问题，S里的所有排列情况就会等于除去x的S的所有排列情况然后将x加到所有的排列情况前面 （x取遍历集合的元素）
; 这个过程是由各个高阶过程组合来的，但是对形状的想象也是一样的
; 比如对于1开头的排列组合= map +1 permutations(2, 3)
;                            map +2 permutations(3) + map +3 permutations(2)
;                                   map +3 '()               map +2 '()
; 总结一下关于递归需要关注的几个点
; 将大问题分解成小问题（如何减小问题的规模），基准情况，计算过程产生的形状
; 而递归能产生正确的答案的关键就在于它能够将小问题的结果归约等到大问题的答案

(define (subsets s)
    (if (null? s)
        (list '())
        (let ((rest (subsets (cdr s))))
            (append rest (map (lambda (x)
                                (cons (car s) x))
                                rest)))))

(define (permutations s)
    (if (null? s)
        '()
        (flatmap (lambda (x)
                    (map (lambda (p) (cons x p))
                         (permutations (remove x s))))
                 s)))

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence)))))

(define (flatmap proc sequence)
    (accumulate append '() (map proc sequence)))

(define (remove item sequence)
    (filter (lambda (x)
                (not (= x item)))
            sequence))

(permutations (list 1 2 3))