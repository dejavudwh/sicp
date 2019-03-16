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

### 流

> 之前我们引入了用局部状态的计算对象来模拟现实世界里具有局部状态的计算对象，而这其中的复杂性来自被模拟对象随着事件变化的在计算机里是通过赋值实现的。那是否存在其他办法避免计算机里的时间对应现实的时间/

> 从数学的角度来想，是否存在一个数学函数，描述一个量x随着时间而变化的行为。如果用离散的步长趣模拟时间，那么我们就可以用一个序列趣模拟一个时间函数，至此，引入一种新的数据结构：流，使用了延时求值技术

###### 流作为延时的表

> 流作为表的一种特殊结构，在构造的时候只构造出流的部分结构，如果需要使用到流的其他部分，这个流就会自动继续构造下去

```
(stream-car (cons-stream x y)) = x
(stream-cdr (cons-stream x y)) = y
```

```
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))
```

###### 流实现的行为方式

```
(cons-stream <a> <b>)
(cons <a> (delay <b>)) ;;可以看作是对未来求值的一个允诺

(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream))) ;;
```

*delay和force的实现*

```
(delay <exp>)其实只是lambda的一层语法糖衣(lambda () <exp>)

(define (force delayed-object)
  (delayed-object))
```
具有记忆的过程

```
(define (memo-proc proc)
  (let ((already-run? false) (result false))
    (lambda ()
      (if (not already-run?)
          (begin (set! result (proc))
                 (set! already-run? true)
                 result)
          result))))

(delay <exp>) = (memo-proc (lambda () <exp>))
```

###### 无穷流

*厄拉多塞筛法，构造出素数的无穷流*

```
(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
           (lambda (x)
             (not (divisible? x (stream-car stream))))
           (stream-cdr stream)))))

(define primes (sieve (integers-starting-from 2)))

;: (stream-ref primes 50)
```

*隐式定义流*

```
(define ones (cons-stream 1 ones))
(define (add-streams s1 s2)
  (stream-map + s1 s2))
(define integers2 (cons-stream 1 (add-streams ones integers2)))
```

###### 流计算模式的使用

*用流表示迭代过程，来不同赋值方法来更新状态变量*

```
(define (sqrt-improve guess x)
  (average guess (/ x guess)))


(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

;: (display-stream (sqrt-stream 2))


(define (pi-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (pi-summands (+ n 2)))))

;: (define pi-stream
;:   (scale-stream (partial-sums (pi-summands 1)) 4))

;: (display-stream pi-stream)
```

*序对的无穷流*

> 推广prime-sum-pairs

```
(define (stream-append s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (stream-append (stream-cdr s1) s2))))

;: (pairs integers integers)


(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))
```

*将流作为信号*

可以采用流，以一种非常直接的方式为信号处理系统建模

- 函数式程序的模块化和对象的模块化

 我们引进赋值的主要收益就是可以增加程序的模块化，把一个大系统的状态进行封装，或者说隐藏到局部变量中。流模型可以提供相应的模块化又不必使用赋值

 *随机数生成器*


 ```
 (define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))


(define random-numbers
  (cons-stream random-init
               (stream-map rand-update random-numbers)))


;: (define cesaro-stream
;:   (map-successive-pairs (lambda (r1 r2) (= (gcd r1 r2) 1))
;:                         random-numbers))

(define (map-successive-pairs f s)
  (cons-stream
   (f (stream-car s) (stream-car (stream-cdr s)))
   (map-successive-pairs f (stream-cdr (stream-cdr s)))))


(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ passed (+ passed failed))
     (monte-carlo
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))
 ```

**时间函数式程序设计观点**

*在之前提款的例子中，同样可以用流的方式来实现那*

```
(define (stream-withdraw balance amount-stream)
  (cons-stream
   balance
   (stream-withdraw (- balance (stream-car amount-stream))
                    (stream-cdr amount-stream))))
```

用对象做模拟是强大的，但也产生了诸如进程的棘手问题，所以推动了函数式程序设计语言的开发。但在另一方面，与时间有关的问题也潜入了函数式模型中，之前对同一个银行操作的例子中，在函数式程序设计时，就需要去归并这两个操作，但是这又引发了对真实时间的依赖，

---

> 在这一节里，主要是根据通过赋值模拟局部状态的计算模型引进的有关时间的问题后，描述了另一种有关模拟时间的另一种方式，也就是流。流的主要核心在于延时计算。继而就可以产生无穷流和模拟系统内部的变化。

> **通过前两章介绍的技术在克服系统复杂性的问题上非常有用，但是我们还需要一种能够指导我们完成系统整体设计的原则，使系统能够自然的划分为具有内聚力的部分，可以更好的维护和修改。从而引进了赋值来模拟现实中具有局部状态的对象来构造计算模型，能够时间的顺序去模拟计算对象的状态。并且在计算对象的交互中，每个子系统内部紧密联系，而与其他子系统之间只存在松散的联系。在引进赋值后，使我们能够更好的进行模块化设计，但同样的也带来了问题，有关时间和对象同一性的问题。再引入赋值后，原先的求值模型显然不适用了，进而引进了环境模型。当我们能够进行赋值时，也就有了更强大的操控复合数据的方法，作者介绍了两种数据结构，队列和表格。之后是两个系统的例子。其中数字电路的模拟式事件驱动为核心来模拟外部时间的变化，其中的make-wire是关键，它包含了一个事件表，在状态改变时，就需要执行它们。第二个例子是约束系统，其中最重要的是约束的传播，系统中的基本元素应该是约束块和连接器。当连接器的值被修改时，它就会通知所有与它有关的约束块，约束块进行检查其它的连接器，进而进行约束的传播。而后就是描述了状态变量改变的时间顺序引发的问题。最后介绍了一种模拟外部时间又能够消除并发问题的惰性数据结构，其中的核心技术也就是延时求值。当然这些都不能完全解决问题，从这一章的最开始，就是构造出一些计算模型，使其能够符合我们对试图去模拟的真实世界（个人觉得说的是模拟于由当前问题出发构建的解世界）的看法，我们可以把世界模拟为一集相互分离的，受时间约束的、具有相互交流的对象。也可以模拟为单一的，无时间无状态的统一体。每种方式都由它的优势，但都不能令人完全满意。我们还在等待着大一统的出现**
