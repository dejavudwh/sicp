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

#### 抽象数据的多重表示

> 在这一节里，我们将学习如何去处理数据，是他们可能在一个程序的不同部分中采用不同的表示方式。这就需要我们去构造通用型过程

##### 复数的表示

*复数有两种不一样的表示方式，也同样更合适不一样的操作*

> 而重要的是，如何让这两种表示方式共存一个系统，并能够在合适的地方调用合适的方法

**带标识数据**

> 可以将数据抽象看作为“最小允诺原则”的一个应用

*如何使两种不同的表示方法共存一个系统的方法就是使用类型标识，在构造数据时为不同表示方式加上类型标识，在进行操作时，根据不同的操作，剖去标识选择合适的操作*

```
;; Ben (rectangular)

(define (real-part-rectangular z) (car z))

(define (imag-part-rectangular z) (cdr z))

(define (magnitude-rectangular z)
  (sqrt (+ (square (real-part-rectangular z))
           (square (imag-part-rectangular z)))))

(define (angle-rectangular z)
  (atan (imag-part-rectangular z)
        (real-part-rectangular z)))

(define (make-from-real-imag-rectangular x y)
  (attach-tag 'rectangular (cons x y)))

(define (make-from-mag-ang-rectangular r a)
  (attach-tag 'rectangular
              (cons (* r (cos a)) (* r (sin a)))))

;; Alyssa (polar)

(define (real-part-polar z)
  (* (magnitude-polar z) (cos (angle-polar z))))

(define (imag-part-polar z)
  (* (magnitude-polar z) (sin (angle-polar z))))

(define (magnitude-polar z) (car z))

(define (angle-polar z) (cdr z))

(define (make-from-real-imag-polar x y)
  (attach-tag 'polar
               (cons (sqrt (+ (square x) (square y)))
                     (atan y x))))

(define (make-from-mag-ang-polar r a)
  (attach-tag 'polar (cons r a)))


;; Generic selectors

(define (real-part z)
  (cond ((rectangular? z)
         (real-part-rectangular (contents z)))
        ((polar? z)
         (real-part-polar (contents z)))
        (else (error "Unknown type -- REAL-PART" z))))

(define (imag-part z)
  (cond ((rectangular? z)
         (imag-part-rectangular (contents z)))
        ((polar? z)
         (imag-part-polar (contents z)))
        (else (error "Unknown type -- IMAG-PART" z))))

(define (magnitude z)
  (cond ((rectangular? z)
         (magnitude-rectangular (contents z)))
        ((polar? z)
         (magnitude-polar (contents z)))
        (else (error "Unknown type -- MAGNITUDE" z))))

(define (angle z)
  (cond ((rectangular? z)
         (angle-rectangular (contents z)))
        ((polar? z)
         (angle-polar (contents z)))
        (else (error "Unknown type -- ANGLE" z))))

```

**数据导向的程序设计和可加性**

*在上面的标识类型最大的问题就是不具备可加性，当我需要再加入另外一种表示方式的时候，我就需要修改类型分派的所以地方，第二不是不允许重名*

> 这时就引进了一种新技术：数据导向。我们以一种具有操作名字，数据类型，实际过程为信息的表格为基础。其中所有的操作都应该到这个表格中查询，所以再增加新操作时也只需要像表格中加入信息。

操作表格：

`(put <op><type><item>)`

`(get <op><type>)`

1. 首先是先安装操作包

```
(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)
```

2. 还是需要进行类型分派

```
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

;; Generic selectors

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))
```

**消息传递**

> 类似面向对象，也就是让每一个操作管理自己的分派

```
(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude)
           (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else
           (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
  dispatch)

(define (apply-generic op arg) (arg op))
```

> 这一小节或许已经能够体现这本书为什么会被人誉为圣经，层层深入，思想毫不过时。这一节里在数据抽象里更深入一层，虽然我们不管数据底层如何实现，但是如果在底层的实现里我们需要更加灵活更加通用又要怎么做呢？书里提到几种技术，类型标识，数据导向，消息传递，而其中所谓的数据导向会不会是在面向对象语言里实现重载的方法呢？而消息传递或许也是面向对象的雏形吧。所以在这更加之上的是，它们都是为了更加通用的系统的目标
