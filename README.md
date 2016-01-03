# 学习lex


## echo

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