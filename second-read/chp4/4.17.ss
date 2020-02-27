#lang scheme

; 首先之所以会扩展一个环境就是因为多加了一个let，不想要这个环境可以改变之前的scan-out-defines，把所有定义放在顶部