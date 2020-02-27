#lang scheme

; 假设try能够中止的，那么(halts? p p)为true，那么会执行(run-forever)，这时陷入死循环，与一开始的假设矛盾
; 假设try能不够中止的，那么(halts? p p)为false，那么会执行'halted，这时try运行结束，与一开始的假设矛盾