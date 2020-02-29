#lang scheme

 ;下面的答案来自wiki

 ;;; Amb-Eval output: 
 ((baker 1) (cooper 2) (fletcher 4) (miller 3) (smith 5)) 
  
 ;;; Amb-Eval input: 
 try-again 
  
 ;;; Amb-Eval output: 
 ((baker 1) (cooper 2) (fletcher 4) (miller 5) (smith 3)) 
  
 ;;; Amb-Eval input: 
 try-again 
  
 ;;; Amb-Eval output: 
 ((baker 1) (cooper 4) (fletcher 2) (miller 5) (smith 3)) 
  
 ;;; Amb-Eval input: 
 try-again 
  
 ;;; Amb-Eval output: 
 ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1)) 
  
 ;;; Amb-Eval input: 
 try-again 
  
 ;;; Amb-Eval output: 
 ((baker 3) (cooper 4) (fletcher 2) (miller 5) (smith 1)) 