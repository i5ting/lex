#! /bin/bash
lex a.lex  && cc -o parser lex.yy.c -ll && ./parser