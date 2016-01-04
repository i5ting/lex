%{ 
unsigned int char_count = 0, word_count = 0, line_count = 0; 
%} 
%%
[^ /t/n]+ {word_count++; char_count+=yyleng;}; 
/n {char_count++; line_count++;}; 
. char_count++; 
%%
char **file_list; 
unsigned int current_file = 0; 
unsigned int total_file = 0; 
 
unsigned int total_cc = 0; 
unsigned int total_wc = 0; 
unsigned int total_lc = 0; 
 
typedef struct file_info{ 
  unsigned int c; 
  unsigned int w; 
  unsigned int l; 
  char *name; 
}INFO; 
 
INFO **all; 
 
 
int create_info(int num) 
{ 
  INFO *tmp; 
  int i; 
  if (num <= 0){ 
    return -1; 
  } 
  all = (INFO **)malloc(sizeof(int *)*num); 
  for (i = 0; i < num; i++){ 
    tmp = (INFO *)malloc(sizeof(INFO)); 
    tmp->c = 0; 
    tmp->w = 0; 
    tmp->l = 0; 
    tmp->name = NULL; 
    all[i] = tmp; 
  } 
  return 1; 
}   
 
int delete_info(int num) 
{ 
  int i; 
  if ((all == (INFO **)0) || num <= 0){ 
    return -1; 
  } 
  for (i = 0; i < num; i++){ 
    free(all[i]); 
  } 
  free(all); 
  return 1; 
} 
 
int set_info(int pos) 
{ 
  int length = 0; 
  if (pos < 0){ 
    return -1; 
  } 
  all[pos]->c = char_count; 
  all[pos]->w = word_count; 
  all[pos]->l = line_count;   
  all[pos]->name = file_list[pos]; 
    
  return 1; 
} 
 
int main(int argc, char** argv) 
{ 
  FILE *file;   
  int position = 0; 
  int i; 
    
  file_list = argv + 1; 
  total_file = argc - 1; 
  current_file = 0; 
    
  printf("--------------------------------------------------------------/n", 
 total_file);  
   
  if (argc > 1){ 
    if (create_info(total_file) == -1){ 
      fprintf(stderr, "%s/n", "Encounter a error when malloc memory."); 
 
      exit(1); 
    } 
  } 
  if (argc == 2){        
      
    file=fopen(argv[1], "r"); 
    if (!file){ 
      fprintf(stderr, "Could not open %s./n", argv[1]); 
      delete_info(total_file); 
      exit(1); 
    }     
    yyin = file; 
  } 
    
  yywrap(); 
  yylex(); 
   
  if (argc > 1){ 
    total_cc += char_count; 
    total_wc += word_count; 
    total_lc += line_count;     
      
    if (set_info(current_file-1) == -1){ 
      fprintf(stderr, "%s/n", "Encounter a error when set information to 
 INFO."); 
      delete_info(total_file); 
      exit(1); 
    }     
      
    for (i = 0; i < total_file; i++){ 
      printf("char:%-8lu word:%-8lu line:%-8lu file name:%s/n", all[i]-> 
c, all[i]->w, all[i]->l, file_list[i]); 
    } 
    printf("----------------------- total --------------------------------
/n"); 
    printf("chars:%-8lu words:%-8lu lines:%-8lu files:%d/n", total_cc, tot 
al_wc, total_lc, total_file); 
  }else{     
    printf("char:%-8lu word:%-8lu line:%-8lu/n", char_count, word_count, l 
ine_count); 
  } 
    
  delete_info(total_file); 
  return 0; 
} 
  
yywrap() 
{ 
  FILE *file = NULL; 
    
  if ((current_file > 0) && (current_file < total_file) && (total_file > 1)) 
{ 
    total_cc += char_count; 
    total_wc += word_count; 
    total_lc += line_count; 
      
    if (set_info(current_file-1) == -1){ 
      fprintf(stderr, "%s/n", "Encounter a error when set information to 
 INFO."); 
      delete_info(total_file); 
      exit(1); 
    }   
      
    char_count = word_count = line_count = 0; 
    fclose(yyin);     
  } 
  while ((file_list[current_file] != (char *)0) && (current_file < total_fil 
e)){ 
      
    file = fopen(file_list[current_file++], "r"); 
    if (!file){ 
      fprintf(stderr, "could not open %s .", file_list[current_file - 1] 
); 
    }else{ 
      yyin = file; 
      break; 
    } 
  } 
  return (file? 0 : 1); 
} 