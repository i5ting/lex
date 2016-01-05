#include <stdio.h>
#include <stdlib.h>
#include <string.h>
enum list_type_tag {
	order_type,
	disorder_type,
} list_type;

enum title_type_tag {
	h1_type,
	h2_type,
} title_type;

void yamd_create_blank_line();
void yamd_create_list_line();
void yamd_add_current_character_to_content(char c);
void yamd_reset_content();
void yamd_add_current_list_line_to_list();

void yamd_output_content();
void yamd_set_list_type(int type);
void yamd_output_list();
void yamd_set_title_type(int type);
void yamd_output_title();
