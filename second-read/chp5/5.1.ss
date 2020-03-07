#lang scheme

Data-Path:
==========

  ┌───────┐   ┌───────┐    ,─.    ┌───────┐
  │   p   │   │   c   ├──>( > )<──┤   n   │
  └─────┬─┘   └───────┘    `─'    └───────┘
    ^   │       │   ^
    │   │       │   │           ^
    X   │       │   X          /1\
    │   │       │   │          ─┬─
    │   │       ├───│───┐       │
    │   v       v   │   v       v
    │  ───────────  │  ───────────
    │   \  mul  /   │   \  add  /
    │    ───┬───    │    ───┬───
    └───────┘       └───────┘


Controller:
===========

        start
          │
          │
          v
          ^
         / \ yes
  ┌────>( > )───> done
  │      \ /
  │       V
  │       │
  │       │no
  │       v
  │  ┌─────────┐
  │  │  p<-mul │
  │  └────┬────┘
  │       │
  │       v
  │  ┌─────────┐
  │  │  c<-add │
  │  └────┬────┘
  └───────┘