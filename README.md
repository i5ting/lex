# 学习lex

## 0.编译

编译分3步

- `lex a.lex`
- `cc -o parser lex.yy.c -ll`
- `./parser`

## 1.echo

和shell里的echo命令一样，实现回声功能

a.lex

```
%%
.|\n  ECHO;
%%
```


编译


```
npm run 1
```

## 2.识别加减乘除


a.lex

```
  %{
  #include "stdio.h"
  %}
  %%
  [\n]                  ;
  [0-9]+                printf("Int     : %s\n",yytext);
  [0-9]*\.[0-9]+        printf("Float   : %s\n",yytext);
  [a-zA-Z][a-zA-Z0-9]*  printf("Var     : %s\n",yytext);
  [\+\-\*\\\%]          printf("Op      : %s\n",yytext);
  .                     printf("Unknown : %c\n",yytext[0]);
  %%
```

说明

- 引入include，这样就可以使用c中的printf函数


执行

测试，指定文件输入

```
npm run 2.1
```

自己输入

```
npm run 2
```
