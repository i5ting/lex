#include "yamd.h"

static char *content = NULL;
static int content_length = 0;
static char *current_list = NULL;
static char *current_list_lines = NULL;

/*
* 给content加上li
*/
void
yamd_create_list_line(){/*{{{*/
	const int size = strlen(content);
	int format_size = strlen("<li></li>");
	/*
	* 把content复制到buf中
	*/
	char buf[size+1];
	strncpy(buf, content, size);
	buf[size] = '\0';
	//扩充content
	content = realloc(content, size+format_size+1);
	sprintf(content, "<li>%s</li>", buf);
	return;
}
/*}}}*/

void
yamd_create_blank_line(){ /*{{{*/
	printf("\n");
	return;
}
/*}}}*/

void
yamd_add_current_character_to_content(char c){/*{{{*/
	//扩充当前content
	if (content_length == 0){
		content = malloc(sizeof(char));
		content[0] = c;
		content_length++;
		return;
	}
	content = realloc(content, content_length+1);
	content[content_length] = c;
	content_length++;
	return;
}
/*}}}*/

void
yamd_reset_content(){ /*{{{*/
	//重置当前content
	if (content){
		free(content);
		content = NULL;
	}
	content_length = 0;
	return;
}
/*}}}*/

void
yamd_output_content(){ /*{{{*/
	if (content != NULL && content_length > 0){
		printf("%s", content);
	}
	return;
}
/*}}}*/

void
yamd_set_list_type(int type){ /*{{{*/
	if (type < 0){
		printf("list type error");
		exit(0);
	}
	list_type = type;
	return;
}
/*}}}*/

void
yamd_add_current_list_line_to_list(){/*{{{*/
	if (content != NULL){
		int size = strlen(content);
		if (current_list_lines == NULL){
			current_list_lines = (char *)malloc(size+1);
			strncpy(current_list_lines, content, size);
			current_list_lines[size] = '\0';
		} else {
			int lines_size = strlen(current_list_lines);
			current_list_lines = realloc(current_list_lines, size+lines_size+1);
			strncpy(current_list_lines+lines_size, content, size);
			current_list_lines[lines_size + size] = '\0';
		}
		//重置content
		yamd_reset_content();
	}
	return;
}
/*}}}*/

void
yamd_output_list(){ /*{{{*/
	if (list_type == order_type){
		printf("<ol>%s</ol>\n", current_list_lines);
	} else if (list_type == disorder_type){
		printf("<ul>%s</ul>\n", current_list_lines);
	}
	free(current_list_lines);
	current_list_lines = NULL;
	return;
}
/*}}}*/

void
yamd_set_title_type(int type){ /*{{{*/
	if (type < 0){
		printf("list type error");
		exit(0);
	}
	title_type = type;
	return;
}
/*}}}*/

void
yamd_output_title(){ /*{{{*/
	if (content != NULL){
		const int size = strlen(content);
		int format_size = strlen("<hX></hX>");
		/*
		* 把content复制到buf中
		*/
		char buf[size+1];
		strncpy(buf, content, size);
		buf[size] = '\0';
		//扩充content
		content = realloc(content, size+format_size+1);
		if (title_type == h1_type){
			sprintf(content, "<h1>%s</h1>", buf);
		} else if (title_type == h2_type) {
			sprintf(content, "<h2>%s</h2>", buf);
		} else {
			printf("%s\n", "error when parse title, unknow title type");
			exit(1);
		}
		//输出title
		printf("%s\n", content);
		//释放content
		yamd_reset_content();
	}
	return;
}
/*}}}*/
