# **SICP CONCLUSION**

> 让我们举起杯，祝福那些将他们的思想镶嵌在重重括号之间的Lisp程序员 ！

> 祝我能够突破层层代码，找到住在里计算机的神灵！

## **<font color = "green">目录</font>**
##### 1. 构造过程抽象
##### 2. 构造数据抽象
##### 3. 模块化、对象和状态
##### 4. 元语言抽象
##### 5. 寄存器机器里的计算

## **<font color = "red">Chapter 3</font>**
- 元语言抽象

##### [练习答案](https://github.com/dejavudwh/SICP-Exercise)

###### 元循环求值器

> **复杂系统设计的通用技术事，将基本元素组合起来，形成复合元素，从复合元素出发通过抽象形成更高一层的构件，并通过采取某种适当的关于系统结构的大尺度观点，保持系统的模块性。随着面对问题复杂性的增加，任一一个程序设计语言都难以表述自己的想法，所以建立新语言成为了工程设计中控制复杂性的一种威力强大的策略。（或者说我们在每个问题的解空间里，构造一门最合适的语言才是最高级的抽象？）**

> **求值器决定了一个程序设计语言中各种表达式的意义，而它本身也不过就是另一个程序而已**

> **事实上，我们几乎可以把任何程序看作是某个语言的求值器**

1. 求值一个表达式，首先求值其中的子表达式，而后将运算符子表达式的值作用于运算对象子表达式的值
2. 在将一个复合过程应用于一集实际参数时，我们在一个新的环境里求值这个过程的体。构造这一环境的方式就是用一个框架扩充该过程对象的环境部分。框架中包含这个过程中形参和实参的约束

求值器的实现依赖于表达式的语法形式，依旧使用数据抽象的想法

- 求值器的内核

```
;;eval
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))
```

apply-primitive-procedure直接应用于基本过程
对于复合过程，需要建立新的环境

```
;;apply
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))
```

> **在从开始构造求值器的内核到运行这个程序，主要使用的还是数据抽象技术，首先所有东西的基础都是Scheme的语法形式，内核可以分为两个部分，1时求值表达式，2是应用过程。在透过数据抽象中可以得到提出每类表达式有关的操作函数，而有关过程的应用分为两个部分，1是基本过程，2是复合过程，复合过程也就是相应表达式在对应环境的求值。**

- 将数据作为程序

将程序看成一种抽象的机器的一个描述，按照这种观点，求值器可以看作一部非常特殊的机器，它要求以一部机器的描述作为输入，给定了一个输入后，求值器就能够规划自己的行为，模拟被描述机器的执行过程。按照这一观点，我们的求值器可以看作是一种通用机器。求值器另一个惊人的地方是它是数据对象和这个程序设计语言本身的桥梁，用户认为输入的是一个表达式，而求值器不过是按照一套良好的规则进行运行。

> 就此来说，任何一个有效的过程都可以描述为一个程序。

```
(define (run-forever) (run-forever))

(define (try p)
  (if (halt? p p)
      (run-forever)
      'halted))

(try try)
```

> 停机定理：是一个良好的刻画工作，但是却不能由一个计算过程来完成，是一个不可计算问题

- 将语法分析与执行分离

之前的求值器实现简单，但是也十分低效，因为语法分析和执行过程交织在一起，所以如果程序要执行多次，语法分析也要做许多次。

```
(define (eval exp env)
  ((analyze exp) env))

(define (analyze exp)
  (cond ((self-evaluating? exp)
         (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))
```

> 这一小节里主要讲的是当面对复杂性提高，而当前语言又难以表述的时候，我们就应该构建一门新的语言了，或者说每个程序都是在构造一门新语言。之后作者实现了Scheme的求值器，在中间提出了图灵的停机定理来引出不可计算问题
