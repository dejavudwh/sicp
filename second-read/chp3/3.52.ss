#lang scheme

在定义y时，seq求值到3，这时候sum = 1 + 2 + 3
z时， sum = 1 + 2 + 3 + 4
在对(stream-ref y)求值的时候，会求值到第七个奇数，sum = 136

而display-stream 会强迫整个流求值

如果不使用记忆过程的话，那么对 seq 流的求值就会产生重复计算，而每次重复对 seq 的流的求值，都会引起 accum 过程的调用，结果会产生一个很不相同的 sum 值。