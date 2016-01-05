%{
/**
* CONTENT_IN_LINE:  普通content中
* LIST_IN_LINE: list内容中
*/

/**
* 问题: 
* 1.test
* +.test2
* 2.test3
* 会输出什么?
*/
#include "yamd.h"

int yywrap(void){
	return 1;
}
%}
%start CONTENT_IN_LINE LIST LIST_IN_LINE TITLE
%%
<INITIAL>"###\ " {
	BEGIN TITLE;
	yamd_set_title_type(h2_type);
}
<INITIAL>"##\ " {
	BEGIN TITLE;
	yamd_set_title_type(h1_type);
}
<TITLE>\n {
	BEGIN INITIAL;
	yamd_output_title();
}
<TITLE>. {
	yamd_add_current_character_to_content(yytext[0]);
}
<INITIAL>"\+ "|"- " {
	BEGIN LIST;
	yamd_set_list_type(1);
}
<INITIAL>([1-9][0-9]*\.\ ) {
	//点号是必须的
	BEGIN LIST;
	yamd_set_list_type(0);
}
<INITIAL>\n{2,} {
	//多个分行只输出一个空行
	yamd_create_blank_line();
}
<INITIAL>\n {
	//创建一个分行
	yamd_create_blank_line();
}
<INITIAL>.   { 
	//开始普通内容
	BEGIN CONTENT_IN_LINE;
	//把当前内容加到content中在CONTENT_IN_LINE中进行处理
	yamd_add_current_character_to_content(yytext[0]);
}
<CONTENT_IN_LINE>\n {
	BEGIN INITIAL;
	//把当前已经有的content打印出来
	yamd_output_content();
	//输出一个分行
	yamd_create_blank_line();
	//重置当前content
	yamd_reset_content();
}
<CONTENT_IN_LINE>. {
	//把它加入到normal content中去
	yamd_add_current_character_to_content(yytext[0]);
}
<LIST>([1-9][0-9]*\.\ ) {
	// ignore
}
<LIST>\n\n {
	//把当前的list输出
	yamd_output_list();
	//回到initial状态
	BEGIN INITIAL;
}
<LIST>\n {
	//创建一个分行
	// TODO 应该是把<br>加入到<ul>中，而不是简单的输出
	yamd_create_blank_line();
}
<LIST>. {
	//把当前加入到content中
	yamd_add_current_character_to_content(yytext[0]);
	BEGIN LIST_IN_LINE;
}
<LIST_IN_LINE>\n {
	//回到ORDER_LIST状态
	BEGIN LIST;
	//首先创建一个list line,即把content补上li标签
	yamd_create_list_line();
	//当前list line加入到ul或者ol中
	yamd_add_current_list_line_to_list();
}
<LIST_IN_LINE>. {
	//把它加入到current list中
	yamd_add_current_character_to_content(yytext[0]);
}
