# **SICP CONCLUSION**

> 让我们举起杯，祝福那些将他们的思想镶嵌在重重括号之间的Lisp程序员 ！

> 祝我能够突破层层代码，找到住在里计算机的神灵！

## **<font color = "green">目录</font>**
##### 1. 构造过程抽象
##### 2. 构造数据抽象
##### 3. 模块化、对象和状态
##### 4. 元语言抽象
##### 5. 寄存器机器里的计算

## **<font color = "red">Chapter 2</font>**
- 构造数据对象

##### [练习答案](https://github.com/dejavudwh/SICP-Exercise)

#### 符号数据

> 这里其实只是引出了符号的表示，重点应该在实例中

###### 实例：符号求导

1. 列出有关求导的基本算法
2. 按愿望思维，先提取出其中有关的基本过程和数据抽象,然后根据算法构造
```
(vairable? e)
(sanme-variable? v1 v2)
(sum? e)
...
（product? e)
```
```
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else
         (error "unknown expression type -- DERIV" exp))))
```
3. 建立细节，实现数据的具体表示和基本过程

```
(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2) (list '+ a1 a2))

(define (make-product m1 m2) (list '* m1 m2))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))

```
4. 上面构造出的只是一个比较粗糙的模型，还需要完善细节
  例如完善化简

###### 实例：集合的表示

- 还是数据抽象的思想，表示出关于集合的操作函数

1. 集合作为未排序的表

```
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))
```

2. 集合作为排序的表(效率的提升)

```
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))
```

3. 集合作为二叉树

- 惯例依旧数据抽象，构建出关于数据的操作函数

```
(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

```

4. 集合与信息检索

提供键值检索

```
(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) false)
        ((equal? given-key (key (car set-of-records)))
         (car set-of-records))
        (else (lookup given-key (cdr set-of-records)))))
```

###### 实例：Huffman编码树

> 算法：使得带有最低频度的符号出现在离树根最远的地方。从叶节点开始，反复找出具有最低权重的两个结点，归并他们

- 树的表示

```
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))
```

- 解码过程

```
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit -- CHOOSE-BRANCH" bit))))
```

> 这里的Huffman树细细体会真的可以体会到数据抽象之威力还是那句讲来讲去的，我无需去关心底层的实现，只要他能保证给我正确的操作

- 带权重元素的集合

> 只需要用adjoin-set来构造树中的表

```
(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set)) ;;这里其实可以抽象出来作为更
        (else (cons (car set)                            ;;一般的排序方法
                    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)
                               (cadr pair))
                    (make-leaf-set (cdr pairs))))))
```

> 这一节首先时引进了符号数据，但之后讲的主要还是去构造数据抽象，只是内容包括了符号数据。介绍了两种数据结构，树和集合，本质上还是讲将他们构造成数据抽象，也就是提供他们的操作函数
