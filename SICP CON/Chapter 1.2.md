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

#### 过程与它们所产生的计算

> 能够看清楚所考虑的动作的后果的能力，对程序设计专家是至关重要的

- **Shape**
  - 线性的递归和迭代

  线性递归过程构造起一个推迟进行的链条，操作也需要维护好将要执行的操作轨迹，深度也是线性增长的
  > 迭代计算过程，那些可以用固定数目的状态变量描述的计算过程，并且存在一套固定的规则描述了计算过程从一个状态倒下一状态的转换

  - 树形递归

  例子:斐波那契数

    `fib(n) = fib(n-1) + fib(n-2)``

    改进方法：依据描述的迭代计算过程，很容易就可以找到斐波那契数里固定数目的状态变量和变换规则

    ```
    (define (fib n)
      (fib-iter 1 0 n))

    (define (fib-iter a b count)
      (if (= count 0)
          b
          (fib-iter b a+b (- count 1))))
    ```

- **实例：换零钱的方式**

<font color="yellow">*递归思考：分解成小问题（完备）->降低问题规模->到最小的退化情况*</font>

`所有换零钱的方式 = 换成除了第一种硬币之外的其他硬币的不同方式数 + 用了第一种硬币后`

```
(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

```

- **增长的阶**
> 描述在消耗计算资源的速率的差异
>>令n一个能作为问题规模的一种度量，令R(N)是一个计算过程在处理规模为N的问题时所需要的资源量
>>>之前求平方根的R(N)就具有f(n)的theta

- **求幂**
> 作者一步步的演示计算过程背后的东西，例如优化它

1. 递归定义：线性递归，需要Θ(n)的空间和Θ(n)的时间

```
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
```

2. 迭代定义：还是根据之前迭代的描述，找出固定的状态变量和一套规则改写它.只要Θ(1)的空间

```
(define (expt b n)
  (expt-iter b n 1))

(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b
                (- counter 1)
                (* b product))))
```
3. 之后的优化算法：连续平方

```
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))
```

- **最大公约数**

> 欧几里得算法：如果r是a除以b的余数，那么a和b的公约数正好是b和r的公约数

```
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
```

- ### 实例：素数检测 ###


1. 寻找因子(增长为Θ(根号2))

```
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))
```

2. 费马检查(增长阶为Θ(log n))

> 费马小定理：如果a是小于n的任意正整数，那么a的n次方与a模n同余

*依旧抽象，拆分各个部件*

```
;;求模
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))        
```

```
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))        
```

***概率方法：***
在费马定理中，通过测试只能说明有很强的证据说明这个数是素数，而且确实存在能够骗过费马定理的整数，在密码学中也有用到概率算法的地方  

> ** 在这小节里：主要讲的是在程序执行的过程中所产生的计算，和这些计算所导致的空间和时间效率，还涉及了一点优化，其中最启发我的还是有关递归的想法：首先递归的主要思想应该是把问题分解成子问题，而且是完备的子问题，能够考虑到所有情况，在最后向上返回的时候才能保证正确，之后是降低规模，如果没有降低规模，递归就毫无意义，而最后降低到的就是最小的退化情况了**
