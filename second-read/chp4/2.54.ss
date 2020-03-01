#lang scheme

 (if (not (true? pred-value)) 
     (fail2) 
     (succeed 'ok fail2)) 