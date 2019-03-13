# **SICP CONCLUSION**

> 让我们举起杯，祝福那些将他们的思想镶嵌在重重括号之间的Lisp程序员 ！

> 祝我能够突破层层代码，找到住在里计算机的神灵！

## **<font color = "green">目录</font>**
##### 1. 构造过程抽象
##### 2. 构造数据抽象
##### 3. 模块化、对象和状态
##### 4. 元语言抽象
##### 5. 寄存器机器里的计算

## **<font color = "red">Chapter 1</font>**
- 构造过程对象

##### [练习答案](https://github.com/dejavudwh/SICP-Exercise)

#### 构造数据对象

> 为什么程序需要复合数据？

- *与我们需要复合过程一样：同样是为了提升我们子设计程序时所位于的概念层次，提高设计的模块性，增强语言的表达能力*

> 数据抽象

- *将那些如何处理数据的部分和数据如何表示分离*

> 怎么去屏蔽数据的表示细节，从而实现更通用的操作呢？

```
(define (linear-combination a b x y)
  (+ (* a x) (* b y)))

(define (linear-combination a b x y)
  (add (mul a x) (mul b y)))
```

> 什么是数据？

> 组成复合数据的关键思想


###### 1. 数据抽象引导

- *在进行过程抽象时，我们隐藏了具体过程的实现细节，这个特定过程完全可以由另一个具有同样整体行为的过程取代，换句话说，我们可以这样造成一个抽象，它将这一过程的使用方式，与该过程究竟如何通过更基本的过程实现的具体细节分离*

- *而数据抽象也同理，也是屏蔽了具体实现和操作它分离，提供的抽象屏障应该是一组选择函数和构造函数*

**1.1 实例：有理数的算术运算**

按愿望思维，假设我们已经有了一组有理数的选择函数和构造函数

```
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

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))
```

  **有理数的表示**

接下来就应该是具体实现有理数的表示，而Scheme给我们提供构造复合数据的工具则是*cons*

```
(define (make-rat n d) (cons n d))

(define (numer x) (car x))

(define (denom x) (cdr x))

;;footnote -- alternative definitions
(define make-rat cons)
(define numer car)
(define denom cdr)

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))
```

**1.2 抽象屏障**

有关这个有理数实例的抽象层次，先是有理数的具体实现，到它的选择和构造函数，有理数的操作方法，到使用有理数的程序

> 把程序各个部分分成不同部分，并且把依赖性限制到少数的几个抽象屏障中，易维护，易修改，且灵活

**1.3 数据意味着什么?**

> 如果说是它由给定的选择函数和构造函数实现的东西，那么显然是不够的

> 书上给出一种解释，我们总可以把数据定义为一组适当的选择函数和构造函数，以及为这些过程是合法表示所需要满足的特特定条件

如果说这就是数据，那么是不是可以说在程序设计中处处都是数据呢？比如cons也是？

```
(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "Argument not 0 or 1 -- CONS" m))))
  dispatch)

(define (car z) (z 0))

(define (cdr z) (z 1))
```

*这小节的练习里主要还是锻炼数据抽象和完善它的能力*

> 这一节里主要讲的还是怎样通过给出一组选择函数和构造函数去构建数据抽象，并且通过一层一层的抽象屏障，把程序的各个部分的依赖性降到最低，或许就是低耦合吧。再接着比较打破观念的就是数据究竟是什么？书上给出一种解释，我们总可以把数据定义为一组适当的选择函数和构造函数，以及为这些过程是合法表示所需要满足的特特定条件
