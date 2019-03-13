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

#### 层次性数据和闭包性质

###### 闭包

> 这个名词来自抽象代数，一集元素称为在某个运算下封闭，如果将这个运算应用于这一集合的元素，产生的依然是该集合的元素（闭包还有另一种意义，书里提到的都是这个性质 ）

> 如果说某组组合数据对象具有闭包性质，那么通过它组合的数据对象得到结果本身还可以通过同样的操作再进行组合

###### 序列的表示和表操作

Scheme里的序列有点儿链表的意思，初看起来非常简陋，但是越往后看越能看见作者是怎样用这个简单的用这个操作构造出复杂的系统

**对表的映射**

书上这里展示了一个对表的映射方法，还是一步一步的构建，提取公共模式，再一次展示了抽象能力，它建立了一种有关表的高级抽象，map帮助我们建起了一层抽象屏障，将实现表变换的过程实现和如何提取表中元素和进行组合结果的细节分离开

###### 层次性结构


**对树的映射**
```
(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree sub-tree factor)
             (* sub-tree factor)))
       tree))
```

>使用Map构造更高级的抽象，个人的思考是，map依旧是一个抽象，提供给它的只是一个变换规则，和一个表，其中变换规则里有递归，而这里的递归子问题就是它的子树也进行变化，最小退化情况就是它已经不是一个序对了

*这一小节讲的也就是怎么利用复合数据去构造更复杂的数据结构，而且是具有抽象能力的*

###### 序列作为一种约定界面

> 在1.3节里，通过实现为告诫过程的程序抽象，抓住处理数值数据的一些程序模式

> 而现在面对复合数据，就我们对操控数据结构的方式有着巨大的依赖性

```
(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
        ((not (pair? tree))
         (if (odd? tree) (square tree) 0))
        (else (+ (sum-odd-squares (car tree))
                 (sum-odd-squares (cdr tree))))))

(define (even-fibs n)
  (define (next k)
    (if (> k n)
        nil
        (let ((f (fib k)))
          (if (even? f)
              (cons f (next (+ k 1)))
              (next (+ k 1))))))
  (next 0))
```
*如果提取公共模式很容易发现其中都有类似流的结构*

  1. 一个枚举器
  2. 一个过滤器
  3. 一个映射
  4. 累积器

**序列操作**

> 重点来了，其中最主要的应该是流之间，各个部件之间所传递的介质，而这种介质在Scheme一般应该是序对。

```
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

;: 过滤器

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;: 累积器

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

;: 枚举

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

;: 枚举

(define (sum-odd-squares tree)
  (accumulate +
              0
              (map square
                   (filter odd?
                           (enumerate-tree tree)))))

(define (even-fibs n)
  (accumulate cons
              nil
              (filter even?
                      (map fib
                           (enumerate-interval 0 n)))))
```

> 将程序表示为一些针对序列的操作，这样做的价值就在于能帮助我们获得模块化的程序，也就是说，得到由一些比较独立的片段的组合构成的设计。通过提供一个标准部件的库，并使这些部件都有着一些能够以各种灵活方式相互连接的约定界面

> 个人理解，这里主要还是通过基于相同的数据结构，来完成抽象和模块化的，比如在面向对象中，一个极具模块化的方法，可能可以接受实现了某个接口的类或者说继承多态也都是为了提高模块化？

> 如果用相同的数据结构作为统一的界面就能保证程序对于数据结构的依赖性只局限到对数据结构的操作

**嵌套映射**

> 这一小节主要讲的还是抽象，第一个首先是Scheme提供的构造复合数据的能力，闭包和序列，最后讲述了一个提高模块化的方法，那就是使用约定的界面，也就是使用相同的数据结构，这样使之能够在各个模块之间相互传递，而其中的依赖性也减少到了对数据结构的操作而已
