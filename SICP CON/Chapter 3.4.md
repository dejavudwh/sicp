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

### 并发：时间是一个本质问题

> 在引入赋值后，迫使我们需要关心事件发生的顺序，从而引发了并发的问题

*限制并行进程之间的交错情况*

###### 对共享变量的串行访问

> 创建一些不同过程的集合，并且保证在每个个串行化集合中至多只有一个过程的执行

```
(parallel-execute <p1><p2><p3>) ;;并发的过程集

;;加入串行化就可以保证独立<p>的运行
(define s (make-serializer))
(parallel-execute <s p1> <s p2>)
```

```
;;存取款
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposit) (protected deposit))
            ((eq? m 'balance) balance)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))
```

- 使用多重共享资源的复杂性

*如果希望交换两个账户的余额就需要对整个过程进行串行化*

```
(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))
```

```
(define (deposit account amount)
  (let ((s (account 'serializer))
        (d (account 'deposit)))
    ((s d) amount)))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
    ((serializer1 (serializer2 exchange))
     account1
     account2)))
```

###### 串行化的实现

> 通过基本的互斥元的同步机制来实现串行化。互斥元是一种对象，有两种基本的操作，获取和释放，一旦互斥元被获取后，任一获取互斥元的操作都需要等到该互斥元被释放

```
(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))
```

*互斥元的实现*

```
(define (make-mutex)
  (let ((cell (list false)))            
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell) ;;如果mutex已经被获取了那么就持续获取这个互斥元直到它被释放
                 (the-mutex 'acquire)))
            ((eq? m 'release) (clear! cell))))
    the-mutex))
```

```
(define (clear! cell)
  (set-car! cell false))

(define (test-and-set! cell)  ;;必须支持原子操作才可能正确
  (if (car cell)
      true
      (begin (set-car! cell true)
             false)))
```

###### 死锁

> 发生在获取线程时产生冲突时，每个进程都需要无穷无尽的等待另一个进程的活动

*避免死锁*

在进行串行化时，为每个进程都安排一个唯一标识，使每个进程都优先进去较低标识标号的账户。这一就不会产生一个交错的冲突，但是还是存在一些情况，需要更复杂的技术

###### 并发性、时间和通信

> 在如今，为了实现高速处理器，出现了流水线、缓存技术，所以并不能保证存储器每刻都保持一致，但像test-and-set!这样的操作都需要检查一个全局变量，所以串行化技术已经被其他新技术代替了

> 在分布式系统中，基本的现象是不同进程之间的同步，建立起共享状态，或迫使进程之间通信所产生的事件都按照某种特定的顺序进行。从本质上看，在并发控制中，任何时间概念都和通信有着内在的密切联系。

---

> 这一节主要讲的是在引入了赋值后，有关并发的概念，提出了一种解决方法：串行化，有关串行化的关键应该是持有的互斥元。最后作者提出了在有关并发的问题中，任何的时间概念都必然和通信存在着内在的密切联系，个人理解也就是说并发实际是在控制事件的发生和对象与对象之间的通信顺序。
