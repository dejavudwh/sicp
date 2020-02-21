#lang scheme

; a)

; 首先每个文件以(部门名字，源文件)的表结构来表示
; 然后由每个部门提供不同的get-record函数，接收一个employee和源文件作为参数

(define (make-hq-file division file)
  (cons division file))
(define (file-division hq-file)
  (car hq-file))
(define (original-file hq-file)
  (cdr hq-file))
 
(define (get-record employee hq-file)
  ((get 'get-record (file-division hq-file))
   employee (original-file hq-file)))
 
(define (has-record? employee division)
  ((get 'has-record? division) employee))

; b)

; 真不知道它说的是什么意思

; c)

(define (find-employee-record employee files)
  (cond ((null? files) (error "FIND-EMPLOYEE-RECORD : No such employee." employee))
        ((has-record? employee (file-division (car files)))
         (get-record employee (car files)))
        (else (find-employee-record
               employee (cdr files)))))
; d)

; 只要实现a)里说到的函数