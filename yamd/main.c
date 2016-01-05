#include "yamd.h"

int main(){
	extern FILE *yyin;
	extern int yylex(void);
	FILE *fp = fopen("test.md", "r");
	yyin = fp;
	if (yylex()){
		printf("error occurs while parse markdown");
		exit(1);
	}
	return 0;
}
