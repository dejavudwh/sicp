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

### 带有通用型操作系统

> 这里讲会实现一个通用型的算术包，大概可以分为几个抽象层

- add sub mul div四个操作，支持所有这个算术包里所有支持的数据
- 有理数算术 复数算术 常规算术
- 最底层的各自实现

#### 使用前一节的数据导向

```
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))

  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))
```

*特殊的在复数算术包中，它构造了两层标志的抽象系统，首先由complex标志引导到复数包，再由rectangular引导到两种表示*

```
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))
```

##### 不同类型的数据组合

> 到目前为止，我们都把算术操作看作是不同类型的单独操作，现在我们要来实现的是跨类型操作

1. 把每个不同类型的操作都安装到表格种

```
;: (define (add-complex-to-schemenum z x)
;:   (make-from-real-imag (+ (real-part z) x)
;:                        (imag-part z)))
;:
;: (put 'add '(complex scheme-number)
;:      (lambda (z x) (tag (add-complex-to-schemenum z x))))
```

> 这一方法的局限非常明显，太复杂，太麻烦

2. 强制类型转换

> 用一个特殊的强制表格存储我们的强制类型变换操作

```
(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

;: (put-coercion 'scheme-number 'complex scheme-number->complex)
```

> 在惊醒操作分派的时候，需要先判断是否需要强制类型转换

```
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
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))
```

*但是这个方法还是由它的局限，如果我们考虑在转换失败的时候，可以通过第三种类型来转换成功。所以就要建立类型的层次结构*

###### 类型的层次结构

> 结构大至是所有的整数都可以看作有理数，有理数又可以看作是实数，实数又可以看作复数

在面对一个类型塔结构的时候，我们在增加新类型时就非常的方便，只要让它作为是谁的超类或者子类，这时也不需要直接定义整数到复数的转换，只需要在每个层次种增加一个转换就可以了。而对于每个类型，都会有一个自己的raise方法。而这里体现的另一种思想就是继承，每个类型都可以继承它的超类所有的方法，也就是说，如果所需操作在给定类型里没有定义，那么我们就开始向塔顶爬升。

但类型层次结构也有它的不足，每个类型可能是多个类型的子类型，也可能是多个类型的超类型

###### 实例：符号代数

- 多项式算术

递归：在多项式计算中，多项式的系数也可能是一个多项式

数据抽象，先提供一套操作函数去进行操作，之后再实现：

```
(define (add-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (add-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- ADD-POLY"
             (list p1 p2))))

(define (mul-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (mul-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- MUL-POLY"
             (list p1 p2))))
```

考虑项表的操作(惯例操作，先提供一套操作函数)：

- empty-termlist?
- adjoin-term
- order
- coeff
- make-term

```
(define (add-terms L1 L2)
  (cond ((empty-termlist? L1) L2)
        ((empty-termlist? L2) L1)
        (else
         (let ((t1 (first-term L1)) (t2 (first-term L2)))
           (cond ((> (order t1) (order t2))
                  (adjoin-term
                   t1 (add-terms (rest-terms L1) L2)))
                 ((< (order t1) (order t2))
                  (adjoin-term
                   t2 (add-terms L1 (rest-terms L2))))
                 (else
                  (adjoin-term
                   (make-term (order t1)
                              (add (coeff t1) (coeff t2))) ;;注意这里使用的是add
                   (add-terms (rest-terms L1)
                              (rest-terms L2)))))))))
```
```
(define (mul-terms L1 L2)
  (if (empty-termlist? L1)
      (the-empty-termlist)
      (add-terms (mul-term-by-all-terms (first-term L1) L2)
                 (mul-terms (rest-terms L1) L2))))

(define (mul-term-by-all-terms t1 L)
  (if (empty-termlist? L)
      (the-empty-termlist)
      (let ((t2 (first-term L)))
        (adjoin-term
         (make-term (+ (order t1) (order t2))
                    (mul (coeff t1) (coeff t2)))
         (mul-term-by-all-terms t1 (rest-terms L))))))
```

> 这里使用add，提现了数据抽象和通用型操作的的威力，这里的多项式的系数可以是任何算术系统里所拥有的，如果将这个多项式计算安装到系统中，系数也就同样支持多项式看，产生一个深度递归

项表的表示

表示形式的选择
  稠密多项式：直接采用其系数作为表
  稀疏多项式：次数和系数的对应作为表

```
(define (adjoin-term term term-list)
  (if (=zero? (coeff term))
      term-list
      (cons term term-list)))

(define (the-empty-termlist) '())
(define (first-term term-list) (car term-list))
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))

(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))
```

**一个多项式可能有由许多不一样的对象组成的，但是这并不会给算术系统造成多大的麻烦，因为在算术系统中使用的数据导向方法会帮我们做出各种正确操作，只需要我们实现了各部分的操作，并且安装到算术系统中**

> 这一节里讲的是通过层层的数据抽象来实现更通用型的系统，在解决底层数据不同表示上，给出了两种方法，一种是类型标识，一种是数据导向。在这个系统中，抽象是层层递进的关系，最顶部的通用操作到每一层的分派到具体操作中。在之后的跨类型操作，提出了继承的概念

> 这一章里主要提出的是数据抽象的概念和构造数据抽象，并利用数据抽象去构造更通用型的操作。其中在Scheme里构造数据抽象依托的是CONS，而其中的关键思想应该是闭包性质，在基于数据抽象的概念上，提出了一个非常有用的概念，就是以数据抽象作为程序中的介质，提高程序的模块性，降低程序的耦合性，把各个模块的依赖性降低到对数据结构的操作，再之后就是引入了符号数据。然后通过层层的丑行构造更通用的算术系统，其中介绍了两种非常有用的方法，类型标识、消息传递和数据导向。其中一样是运用之前所讲的分层思想，每一个层次都有自己的基本元素和组合方法抽象方法，最后就是再进行跨类型操作引入的类型塔中提到的继承概念，旨在建立对象和对象之间的联系
