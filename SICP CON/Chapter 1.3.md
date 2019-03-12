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

### [练习答案](https://github.com/dejavudwh/SICP-Exercise)

#### 用高阶函数做抽象

<font color = "pink">*或许这就是函数式和面向对象各有吸引人的地方吧，函数式的硬通货是过程，面向对象则是对象*</font>

> 人们对功能强大的程序设计有一个必然要求，就是能为公共模式命名，建立抽象，而后直接在抽象的层次上工作

- ###### 过程作为参数

三个例子：

```
(define (sum-integers a b)
  (if (> a b)
      0
      (+ a (sum-integers (+ a 1) b))))

(define (sum-cubes a b)
  (if (> a b)
      0
      (+ (cube a) (sum-cubes (+ a 1) b))))

(define (pi-sum a b)
  (if (> a b)
      0
      (+ (/ 1.0 (* a (+ a 2))) (pi-sum (+ a 4) b))))
```

*三个例子存在着很明显的公共模式，也即说明可以建立非常强大的抽象*
1. 需要进行加法的操作函数
2. 获得下一个值的函数
3. 对两个参数的特定操作，+ ？

> 在思考的是，面向对象中，相关的想法是怎么样的。如果在一个类中，会存在许多可以提取公共模式的方法吗？或者说这是Java中许多类共有的方法的思想来源，在操作时传递有相同方法的类，但方法中又有类型参数的限制，所以？继承or多态等等吗... 工具函数

```
;; 扩展到积分操作
(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2)) add-dx b)
     dx))

;: (integral cube 0 1 0.01)

;: (integral cube 0 1 0.001)
```

*练习中的过滤器*

```
(define (filtered-accumulate combiner null-value term a next b filter)
  (if (> a b)
      null-value
      (if (filter a)
          (combiner (term a) (filtered-accumulate combiner null-value term (next a) next b filter))
          (combiner null-value (filtered-accumulate combiner null-value term (next a) next b filter)))))
```

- ###### 用lambda构造过程

> 作为一个匿名函数去传递

1. 用let创建局部变量

```
(let ((<var><exp>)
       <var><exp>))
       body)
```
*但其实是作为lambda的语法糖而已*

```
((lambda (<var1><var2>)
  <body>)
  <exp>
  <exp>)
```

2. 过程作为一般性的方法

> 更高级的抽象：描述一般性的方法，不依赖特定的数值或者函数

- 通过区间折半寻找方程的跟

```
(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
        midpoint
        (let ((test-value (f midpoint)))
          (cond ((positive? test-value)
                 (search f neg-point midpoint))
                ((negative? test-value)
                 (search f midpoint pos-point))
                (else midpoint))))))
```

```
;; 抽象出来的作为基本的谓词过程
(define (close-enough? x y)
  (< (abs (- x y)) 0.001))
```

*改进这个方法，如果同号就无法使用折半*

```
(define (half-interval-method f a b)
  (let ((a-value (f a))
        (b-value (f b)))
    (cond ((and (negative? a-value) (positive? b-value))
           (search f a b))
          ((and (negative? b-value) (positive? a-value))
           (search f b a))
          (else
           (error "Values are not of opposite sign" a b)))))
```

- 找出函数不动点

```
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))
```

*回想到之前讲的求平方根，一样可重新用这个一般性方法实现*

3. 过程作为返回值

书上这里用的是平均阻尼和之前的不动点一起构成作为例子，但是核心点还是构造更加抽象更加一般性的方法

```
(define (average-damp f)
  (lambda (x) (average x (f x))))

;: ((average-damp square) 10)

(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y)))
               1.0))

(define (cube-root x)
  (fixed-point (average-damp (lambda (y) (/ x (square y))))
               1.0))
```
> 将一个计算过程形式化为一个过程，一般说，存在着许多不同的方式，有经验的程序员知道如何选择过程的形式，使其特别清晰且易理解，使该计算过程中有用的元素能表现为一些相互分离的个体，并使他们可能重新用于其他的应用

4. 抽象和第一级过程

- 第四小节主要是在先前的一般性方法继续进行抽象，使之成为更加一般的操作

- 在不同的程序设计语言中，第一级都可能有所不同，而第一级元素也正是一个语言中最具魅力也是最不同的地方，也是因为它被赋予的某些特权：
  1. 可以用变量命名
  2. 可以提供给过程作为参数
  3. 可以由过程作为结果返回
  4. 可以包含在数据结构中

> 这一节里，应该可以说是字字不离抽象了。从一开始的过程作为参数，作为返回值，匿名过程，到最后的构建更具有一般性的方法。都是为了使之更具有模块化、通用性。而在思考到面向对象中，它的第一级元素肯定是对象，万物皆过程，万物皆对象可能就是他们之间各具魅力的地方吧，而其中的继承、多态、重载是不是都为了更好的获得一般性方法的描述呢？
