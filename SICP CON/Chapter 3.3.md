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

### 用变动数据做模拟

> 当引入赋值后就可以在之前为那些复合数据对象提出改变函数

###### 变动的表结构

- 针对cons的基本改变函数，set-car!和set-cdr!函数

- 共享和相等

```
;: (define x (list 'a 'b))
;: (define z1 (cons x x))
;: (define z2 (cons (list 'a 'b) (list 'a 'b)))
```

*如果从只进行car、cdr操作来看，可以说z1,z2是同一个对象，但是如果从其他角度看，z1里很明显是有一个共享的结构，如果改变了car一样也会改变cdr。这种结构可以极大的扩展用序对表示的数据结构的范围，但一样也会带来风险*

- 改变也就是赋值

*为了表现变动数据的行为，所需要的全部东西也就是赋值*

- 队列的表示

> 队列就是一个数据项从一端进入从另一端删除的序列

*从数据抽象的说法，队列以可由下面一组操作函数定义*

```
(front-ptr queue)
(rear-ptr queue)
(set-front-ptr! queue item)  
(set-rear-ptr! queue item)  
(empty-queue? queue)  
(make-queue)  
(front-queue queue)
(insert-queue! queue item)
(delete-queue! queue)
```

> 在具体实现上可以用一个序对来表示队首和队尾的指针，提高效率

```
(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue)))
```

- 表格的表示

在表格里，每个值保存在一个关键码之下，将它们组合组合成一个序对。再将它们类似链表连接起来，每个car指向记录，cdr指向下一个索引。

```
(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        false)))

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)

(define (make-table)
  (list '*table*))
```

*二维表格*

![ ](http://baidu.com/pic/doge.png)

> 再查找数据项时，可以先用第一个关键码进行搜索，如果不存在再用第二个搜索

```
(define (lookup key-1 key-2 table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (cdr record)
              false))
        false)))

(define (insert! key-1 key-2 value table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (set-cdr! record value)
              (set-cdr! subtable
                        (cons (cons key-2 value)
                              (cdr subtable)))))
        (set-cdr! table
                  (cons (list key-1
                              (cons key-2 value))
                        (cdr table)))))
  'ok)

```

*面向对象思想创建局部表格*

```
(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))
```

- ##### 数字电路的模拟器

*事件驱动的模拟*
*Java中的事件监听实现*

在电路里有关的计算模型
  1. wire连线
  2. 基本的功能块（反门）

对基本计算模型的操作

```
;: (define a (make-wire))
;: (define b (make-wire))
;: (define c (make-wire))
;: (define d (make-wire))
;: (define e (make-wire))
;: (define s (make-wire))
;:
;: (or-gate a b d)
;: (and-gate a b c)
;: (inverter c e)
;: (and-gate d e s)
```

通过基本的操作构成更高级的操作

```
(define (half-adder a b s c)                ;;半加器
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (full-adder a b c-in sum c-out)     ;;全加器
  (let ((s (make-wire))
        (c1 (make-wire))
        (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))
```

*基本功能块*

```
(get-signal! <wire)) ;;获得连线的信号值
(set_signal! <wire><new value>) ;;修改连线的信号值
(add-action! <wire><procedure of no arguments>) ;;事件监听
(after-delay <delay><procedure) ;;时间延迟
```

```
(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
        (else (error "Invalid signal" s))))
```

```
(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
           (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)
```

- 线路的表示

*由一个信号值和一组关联的过程，在信号值改变时，这组过程都要运行，也就是事件驱动*

```
(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
          (begin (set! signal-value new-value)
                 (call-each action-procedures))
          'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-my-signal!)
            ((eq? m 'add-action!) accept-action-procedure!)
            (else (error "Unknown operation -- WIRE" m))))
    dispatch))

    (define (call-each procedures)
  (if (null? procedures)
      'done
      (begin
        ((car procedures))
        (call-each (cdr procedures)))))
```

- 待处理表来实现after-delay（用来模拟在这个系统中所有状态改变的时间概念）

*惯例，根据数据抽象的思想给出操作函数*
```
(make-agenda)
(empty-agenda? <agenda>)
(first-agenda-item <agenda>)
(remove-first-agenda-item! <agenda>)
(add-to-agenda! <time> <action> <agenda>)
```

```
(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
                  action
                  the-agenda))

(define (propagate)
  (if (empty-agenda? the-agenda)
      'done
      (let ((first-item (first-agenda-item the-agenda)))
        (first-item)
        (remove-first-agenda-item! the-agenda)
        (propagate))))
```

- 待处理表的实现

*这些待处理表由一些时间段组成，每个时间段是由一个数值（表示时间）和一个队列组成的序列*

```
(define (make-time-segment time queue)
  (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))
```

```
;;一维表格来实现
(define (make-agenda) (list 0))

(define (current-time agenda) (car agenda))
(define (set-current-time! agenda time)
  (set-car! agenda time))

(define (segments agenda) (cdr agenda))
(define (set-segments! agenda segments)
  (set-cdr! agenda segments))
(define (first-segment agenda) (car (segments agenda)))
(define (rest-segments agenda) (cdr (segments agenda)))

(define (empty-agenda? agenda)
  (null? (segments agenda)))
```

```
;;如果表为空，就创建新的时间段加入，如果具有合适的时间就加入到关联的队列中，如果碰到了更晚的时间，就需要插入新的时间段
(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
        (< time (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
        (insert-queue! (segment-queue (car segments))
                       action)
        (let ((rest (cdr segments)))
          (if (belongs-before? rest)
              (set-cdr!
               segments
               (cons (make-new-time-segment time action)
                     (cdr segments)))
              (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
        (set-segments!
         agenda
         (cons (make-new-time-segment time action)
               segments))
        (add-to-segments! segments))))
```

```
(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue? q)
        (set-segments! agenda (rest-segments agenda)))))

(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
      (error "Agenda is empty -- FIRST-AGENDA-ITEM")
      (let ((first-seg (first-segment agenda)))
        (set-current-time! agenda (segment-time first-seg))
        (front-queue (segment-queue first-seg)))))
```

- ##### 约束的传播

> 一种的语言设计

1. 基本元素：基本约束

描述不同量之间的某种特定关系

2. 基本方法：用来组织各种基本约束

通过约束网络的方法组合起各种约束，使用连接器连接

*当某个连接器被给定了一个值时，它就会去唤醒所有与之关联的约束（除了刚刚唤醒它的Negev约束），通知它们自己有了一个新值。被唤醒的每个约束块将去盘点自己的连接器，看看是否能够为连接器确定一个值，。如果可能的话，就设置相应的连接器，该连接器又会去唤醒与之连接的约束*

- 约束系统的使用

```
;; 9C = 5(F-32)
;: (define C (make-connector))
;: (define F (make-connector))
;: (celsius-fahrenheit-converter C F)

(define (celsius-fahrenheit-converter c f)
  (let ((u (make-connector))
        (v (make-connector))
        (w (make-connector))
        (x (make-connector))
        (y (make-connector)))
    (multiplier c w u)
    (multiplier v x u)
    (adder v y f)
    (constant 9 w)
    (constant 5 x)
    (constant 32 y)
    'ok))
```

- 约束系统的实现

```
;;连接器的基本操作
(has-value? <connector>)
(get-value <connector>)
(set-value! <connector><new-value><informant>)
(forget-value! <connector><retractor>)
(connect <connector><new-constraint>)
```

```
;;求和器
(define (adder a1 a2 sum)
  (define (process-new-value)
    (cond ((and (has-value? a1) (has-value? a2))
           (set-value! sum
                       (+ (get-value a1) (get-value a2))
                       me))
          ((and (has-value? a1) (has-value? sum))
           (set-value! a2
                       (- (get-value sum) (get-value a1))
                       me))
          ((and (has-value? a2) (has-value? sum))
           (set-value! a1
                       (- (get-value sum) (get-value a2))
                       me))))
  (define (process-forget-value)
    (forget-value! sum me)
    (forget-value! a1 me)
    (forget-value! a2 me)
    (process-new-value))
  (define (me request)
    (cond ((eq? request 'I-have-a-value)  
           (process-new-value))
          ((eq? request 'I-lost-my-value)
           (process-forget-value))
          (else
           (error "Unknown request -- ADDER" request))))
  (connect a1 me)
  (connect a2 me)
  (connect sum me)
  me)

;;语法界面
(define (inform-about-value constraint)
  (constraint 'I-have-a-value))

(define (inform-about-no-value constraint)
  (constraint 'I-lost-my-value))
```

```
;;常量块设置连接器的值
(define (constant value connector)
  (define (me request)
    (error "Unknown request -- CONSTANT" request))
  (connect connector me)
  (set-value! connector value me)
  me)
```

```
;;消息打印
(define (probe name connector)
  (define (print-probe value)
    (newline)
    (display "Probe: ")
    (display name)
    (display " = ")
    (display value))
  (define (process-new-value)
    (print-probe (get-value connector)))
  (define (process-forget-value)
    (print-probe "?"))
  (define (me request)
    (cond ((eq? request 'I-have-a-value)
           (process-new-value))
          ((eq? request 'I-lost-my-value)
           (process-forget-value))
          (else
           (error "Unknown request -- PROBE" request))))
  (connect connector me)
  me)
```

- 连接器的表示

```
;; 通过保存所有约束，之后再通过set-my-value唤醒所有约束
(define (make-connector)
  (let ((value false) (informant false) (constraints '()))
    (define (set-my-value newval setter)
      (cond ((not (has-value? me))
             (set! value newval)
             (set! informant setter)
             (for-each-except setter
                              inform-about-value
                              constraints))
            ((not (= value newval))
             (error "Contradiction" (list value newval)))
            (else 'ignored)))
    (define (forget-my-value retractor)
      (if (eq? retractor informant)
          (begin (set! informant false)
                 (for-each-except retractor
                                  inform-about-no-value
                                  constraints))
          'ignored))
    (define (connect new-constraint)
      (if (not (memq new-constraint constraints))
          (set! constraints
                (cons new-constraint constraints)))
      (if (has-value? me)
          (inform-about-value new-constraint))
      'done)
    (define (me request)
      (cond ((eq? request 'has-value?)
             (if informant true false))
            ((eq? request 'value) value)
            ((eq? request 'set-value!) set-my-value)
            ((eq? request 'forget) forget-my-value)
            ((eq? request 'connect) connect)
            (else (error "Unknown operation -- CONNECTOR"
                         request))))
    me))
```

```
;;遍历通知连接器所有约束
(define (for-each-except exception procedure list)
  (define (loop items)
    (cond ((null? items) 'done)
          ((eq? (car items) exception) (loop (cdr items)))
          (else (procedure (car items))
                (loop (cdr items)))))
  (loop list))
```

```
;;语法界面
(define (has-value? connector)
  (connector 'has-value?))

(define (get-value connector)
  (connector 'value))

(define (set-value! connector new-value informant)
  ((connector 'set-value!) new-value informant))

(define (forget-value! connector retractor)
  ((connector 'forget) retractor))

(define (connect connector new-constraint)
  ((connector 'connect) new-constraint))
```

> 这一节里主要讲的是在引入在引入了赋值之后就可以构造可以改变的数据结构，介绍了两种数据结构：队列和表格。 也讲了两种关于时间和状态的例子，一个是数字电路的模拟，采用事件驱动的方式来维护计算模型之间的状态，在线路中保存所有关联的操作，当线路信号值改变就会驱动所有关联事件，并且用一个待处理表来模拟事件延迟，也就是保存设置信号值的操作。在第二个例子里使用了约束的传播，核心是连接器和约束块，当连接器发生改变就会通知约束块，约束块又会通知其他连接器，进行传播
