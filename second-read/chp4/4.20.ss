#lang scheme

(define (letrec? exp)
  (tagged-list exp 'letrec))
(define (letrec-bindings exp)
  (cadr exp))
(define (letrec-binding-vars exp)
  (map car (letrec-bindings exp)))
(define (letrec-binding-vals exp)
  (map cadr (letrec-bindings exp)))
(define (letrec-body exp)
  (cddr exp))

(define (make-unassigned-bindings vars)
  (map (lambda (var) (cons var '*unassigned*)) vars))

(define (make-set-clauses vars vals)
  (map (lambda (var val) (list 'set! var val)) vars vals))


(define (letrec->let exp)
  (let ((vars (letrec-binding-vars exp))
        (vals (letrec-binding-vals exp)))
    (make-let (make-unassigned-bindings vars)
              (append (make-set-clauses vars vals)
                      (letrec-body exp)))))


; b)

以下的答案来自wiki

Letrec Environment Diagram
==========================
Even? and odd? procs reference E2 because the are created when evaluating
set! within the body of the lambda.  This means they can lookup the even?
and odd? variables defined in this frame.

global env ──┐
             v
┌───────────────────────────┐
│                           │
│(after call to define)     │
│f:┐                        │<─────────────────────────────┐
└───────────────────────────┘                              │
   │  ^                                                    │
   │  │                                  call to f         │
   v  │                          ┌─────────────────────────┴─┐
  @ @ │                          │x: 5                       │
  │ └─┘                     E1 ->│                           │
  v                              │                           │<───┐
parameter: x                     └───────────────────────────┘    │
((lambda (even? odd?)                                             │
   (set! even? (lambda (n) ...)                                   │
   (set! odd? (lambda (n) ...)             call to letrec/lambda  │
   (even? x))                           ┌─────────────────────────┴─┐
 *unassigned* *unassigned*)             │even?:─────────────────┐   │
                                   E2 ->│odd?:┐                 │   │
                                        │     │                 │   │
                                        └───────────────────────────┘
                                              │  ^              │  ^
                                              │  │              │  │
                                              v  │              v  │
                                             @ @ │             @ @ │
                                             │ └─┘             │ └─┘
                                             v                 v
                                        parameter: n      parameter: n
                                      (if (equal? n 0)  (if (equal? n 0)
                                          false             true
                                          ...               ...

Let Environment Diagram
=======================
Even? and odd? procs reference E1 because they are evaluated in the body of
f but outside the 'let lambda' because they are passed as arguments to that
lambda.  This means they can't lookup the even? and odd? variables defined
in E2.

global env ──┐
             v
┌───────────────────────────┐
│                           │
│(after call to define)     │
│f:┐                        │<─────────────────────────────┐
└───────────────────────────┘                              │
   │  ^                                                    │
   │  │                                  call to f         │
   v  │                          ┌─────────────────────────┴─┐
  @ @ │                          │x: 5                       │<───────────┐
  │ └─┘                     E1 ->│                           │<─────────┐ │
  v                              │                           │<───┐     │ │
parameter: x                     └───────────────────────────┘    │     │ │
((lambda (even? odd?)                                             │     │ │
   (even? x))                                                     │     │ │
 (lambda (n) (if (equal? n ...))           call to let/lambda     │     │ │
 (lambda (n) (if (equal? n ...)))       ┌─────────────────────────┴─┐   │ │
                                        │even?:─────────────────┐   │   │ │
                                   E2 ->│odd?:┐                 │   │   ^ │
                                        │     │                 │   │   │ │
                                        └───────────────────────────┘   │ │
                                              │                 │       │ │
                                              │  ┌──────────────────────┘ ^
                                              │  │              │         │
                                              v  │              v         │
                                             @ @ │             @ @        │
                                             │ └─┘             │ └────────┘
                                             v                 v
                                        parameter: n      parameter: n
                                      (if (equal? n 0)  (if (equal? n 0)
                                          false             true
                                          ...               ...