%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  int yywrap();
  int lineno=1;
%}

delim [ \t] 
ws {delim}+   
letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*
number {digit}+
error_id ({digit})+({letter})+
enter [ \n]
spchar ("{"|"}"|"["|"]"|"("|")"|";"|"="|",")
ariop ("+"|"-"|"*"|"/")
relop ("<"|"<="|">"|">="|"=="|"!=")
comment \/\*(\*[^/]|[^*])*\*\/
reswd (int|else|return|void|if|while)

%%
{ws} {}
{comment} {}
{enter} {lineno++;}
{reswd} {fprintf(yyout,"%d行\tkeywod\t%s\n",lineno,yytext);}
{spchar} {fprintf(yyout,"%d行\tspchar\t%s\n",lineno,yytext);}
{id} {fprintf(yyout,"%d行\tidentifier\t%s\n",lineno,yytext);}
{number} {fprintf(yyout,"%d行\tnumber\t%s\n",lineno,yytext);}
{error_id} {fprintf(yyout,"%d行\terror_id\t%s\n",lineno,yytext);}
{ariop} {fprintf(yyout,"%d行\tari_op\t%s\n",lineno,yytext);}
{relop} {fprintf(yyout,"%d行\trel_op\t%s\n",lineno,yytext);}
%%

int yywrap() {return 1;}

int main(void)
{
	char infilename[100];
	printf("输入文件名：");
	scanf("%s",infilename);
	yyin = fopen(infilename,"r");
	yyout = fopen("out","w");
	yylex();
	return 0;
}
