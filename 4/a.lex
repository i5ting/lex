%{
  #include <stdlib.h>
  int wordCount = 0;
%}
%%
[A-za-z\_\'\.\"] ;
([0-9])+ ;
[" "\n\t];
whitespace;
words { wordCount++;}

%%

int main()
{
  yylex(); 
  printf(" No of words:%d\n", wordCount);
}

int yywrap()
{
  return 1;
}