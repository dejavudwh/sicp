#lang scheme

; 3.48的方法之所以能够工作，是因为我们提前知道接下来可能会执行的进程，所以只要重新安排顺序就可以避免死锁

; 所以只要安排一个接下来要运行的进程，必须要在运行时决定时，之前的方法就不管用了