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
- 模块化、对象和状态

##### [练习答案](https://github.com/dejavudwh/SICP-Exercise)

> 从前两章中我们认识到，在克服系统复杂性问题时，构造过程抽象和数据抽象祈祷了非常关键的作用。但是在进行组织模块化后，我们还需要一些组织原则来完成系统的整体设计，使这些系统自然地划分为内聚的部分

> 有一种强有力的设计策略，就是基于外界事物的结构，去模拟设计，也就是划分每个计算对象，也就是面向对象思想，这一策略的好处也就是在扩展修改增加程序时，只需要做一些局部的工作

> 另外一种策略是将注意力集中在流过系统的信息流上

### 赋值和局部状态

*作为一个对象，我们就可以算它的状态是受时间或者历史影响的，那么就需要表示它的状态变量，而所谓的交互就是建立对象与对象之间状态变量的联系，形成内部联系紧密，而与其他子系统只存在着松散的联系*

- 银行账户例子

```
balance 100
;: (withdraw 25)
75
;: (withdraw 25)
50
;: (withdraw 60)
Not enough
;: (withdraw 15)
35
```

```
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
  dispatch)

;: (define acc (make-account 100))

;: ((acc 'withdraw) 50)
;: ((acc 'withdraw) 60)
;: ((acc 'deposit) 40)
;: ((acc 'withdraw) 60)

```

- 引进赋值带来的利益

*蒙特卡洛模拟例子*

> 6/Π2是随机选取两个整数之间没有公共因子的概率

**使用了随机数生成器：内部拥有状态变量**

```
(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro-test))))

(define (cesaro-test)
   (= (gcd (rand) (rand)) 1))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))
```

**不使用随机数生成器**

```
(define (estimate-pi trials)
  (sqrt (/ 6 (random-gcd-test trials random-init))))

(define (random-gcd-test trials initial-x)
  (define (iter trials-remaining trials-passed x)
    (let ((x1 (rand-update x)))
      (let ((x2 (rand-update x1)))
        (cond ((= trials-remaining 0)   
               (/ trials-passed trials))
              ((= (gcd x1 x2) 1)
               (iter (- trials-remaining 1)
                     (+ trials-passed 1)
                     x2))
              (else
               (iter (- trials-remaining 1)
                     trials-passed
                     x2))))))
  (iter trials 0 initial-x))
```
> 虽然现在还没有看出非常大的问题，但是其中已经破坏了程序的模块性，而且暴露本应该是内部的状态变量。而之前的程序反应出的是一个复杂的计算性过程，其他部分都像在随着时间不断变化，并且隐藏起随时间变化的内部，而这就需要局部变量去模拟系统的状态，并用赋值来模拟它们的变化。增强模块性

- 引进赋值的代价

> 引进了赋值可以去模拟系统的变化，但是这也迫使我们需要引进新的计算模型，因为代换模型已经不适用了。如果我们不使用赋值，以同样参数对同一过程的两次求值可以产生同样的的结果，这样的就称为*函数式程序设计*

```
(define (make-decrementer balance) ;; 函数式编程，所以两次调用并不能改变状态
  (lambda (amount)
    (- balance amount)))
```

- 同一和变化

> 一旦我们将变化引进了我们的计算模型，首先考虑两个物体实际上同一的概念

```
;: (define D1 (make-decrementer 25))
;: (define D2 (make-decrementer 25))
```
*如果我们说D1 D2是同一的是可接受的，因为调用它并不会改变其内部状态*

```
;: (define W1 (make-simplified-withdraw 25))
;: (define W2 (make-simplified-withdraw 25))
```
*但是W1 W2很显然就不是同一的了*

> 如果一个语言支持在表达式里“同一的东西可以替换”，那么久称这个语言是具有引用透明性的

> 我们只能通过改变一个对象，去观察另一个对象是否发生变化，以此来判断这两个是不是同一的，但如果不能通过观察对象两次，看看一次观察中看到的某些对象性质是否与另一次不同，我们又怎么能清楚一个对象是否变化了呢？所以如果没有有关同一的某些先验观念，我们也就不能确定变化，而不能看到变化久不能确定同一性

```
1)
;: (define peter-acc (make-account 100))
;: (define paul-acc (make-account 100))
;:
2)
;: (define peter-acc (make-account 100))
;: (define paul-acc peter-acc)
```

**在第一种情况下，很显然这两个是不同对象，但在2中，修改一个对象也就会修改另外一个对象，所以在构造计算模型的时候，就很容易引起混乱，比如在面向对象中有关对象的传递，同一或许有点让人迷惑。但是如果我们保证绝不修改数据对象，那么有关同一的概念就又不同了，就可以将一个数据对象完全看作是由其片段组成的了。在有理数中可以看作它是由分子分母组成的，所以如果修改了它的分字或者分母，它就不在是一个同一对象了。但是对于银行账户，如果你改变了它的账户，它依旧是同一对象。**

- 命令式函数设计的缺陷

**在命令式函数中广泛使用赋值，这就会引进一个复杂的问题，就是赋值的顺序，状态有关时间的变化**

> 这一节主要是在需要一种更好的组织系统的设计方式后，一种是面向对象的方式，一种是流的方式，在基于面向对象的基础上引入了局部变量和赋值来描述计算模型的状态，这样的好处的是使程序更加的具有模块化，在每个模块中都有自己的局部变量去描述自身的状态，但这其中也有代价，就是发生了同一概念的复杂性
