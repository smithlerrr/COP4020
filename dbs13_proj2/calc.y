%{
/*
  Drew Smith
  COP4020
  Project 2
  Due Date: 3/4/2016
*/

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  
  FILE *outfile;
  int yyline = 1; 
  int yycolumn = 1;
  char string_table[20000];

  struct data{
    char buf[5000];
    int val;
    int full;
  };

  void yyerror(const char *x);
  void print_header();
  void print_end();
  void print_exp(const char *c);
  struct data data_table[100];
  int table_index = 0;
%}

%union{
  int sv;
  struct {
    int val;
    char buf[1000];
  }attr;
}

%token PRINTnumber
%token PROGRAMnumber
%token ISnumber
%token BEGINnumber
%token ENDnumber
%token VARnumber
%token DIVnumber
%token SEMInumber
%token LPARENnumber
%token MINUSnumber
%token TIMESnumber
%token COMMAnumber
%token RPARENnumber
%token PLUSnumber
%token EQnumber
%token <sv> IDnumber
%token <sv> ICONSTnumber

%type <attr> compound_statement
%type <attr> exp
%type <attr> statement
%type <attr> statements
%type <attr> declarations
%type <attr> declaration
%type <attr> term
%type <attr> factor

%%

program: PROGRAMnumber IDnumber ISnumber compound_statement{}
  ;

compound_statement: BEGINnumber{print_header();} statements{} ENDnumber{print_end();}
  ;

statements: statement
  {
    strcpy($$.buf, $1.buf);
    fprintf(outfile, "%s", $1.buf);
  }
  
| statements SEMInumber statement
  {
    strcpy($$.buf, $1.buf);
    strcat($$.buf, ";\n"); 
  }
  ;

statement: IDnumber EQnumber exp
  {
    int index = Valid(string_table + $1); 
    if (index != -1)
    {
      data_table[index].full = 1;
      data_table[index].val = $3.val;
    }

    char *hold = string_table+$1;
    strcpy($$.buf, hold);
    strcat($$.buf, " = ");
    strcat($$.buf, $3.buf);
    strcat($$.buf, "; ");
    fprintf(outfile, "%s\n", $$.buf);
  }
  
| PRINTnumber exp
  {
    printf("%d\n", $2.val);
    print_exp($2.buf);
  }

| declarations
  {
    $$.val = $1.val;
    strcpy($$.buf, $1.buf);
  }

declarations: declaration
  {
    strcpy($$.buf, $1.buf);
  }

| declarations COMMAnumber IDnumber
  {
    char *temp = string_table + $3;
    data_table[table_index].full = 0;
    strcpy(data_table[table_index].buf, temp);
    table_index++;
    strcpy($$.buf, $1.buf);
    strcpy($$.buf, ", ");
    strcpy($$.buf, temp); 
  }
  ;

declaration: VARnumber IDnumber
  {
    char *temp = string_table+$2;
    int hold = Valid(temp);
    data_table[table_index].full = 0;
    strcpy(data_table[table_index].buf, temp);
    table_index++;

    strcpy($$.buf, "int");
    strcat($$.buf, " ");
    strcat($$.buf, temp);
  }
  ;

exp: term
  {
    $$.val = $1.val;
    strcpy($$.buf, $1.buf);
  }

| exp PLUSnumber term
  {
    $$.val = $1.val + $3.val;
    strcpy($$.buf, $1.buf);
    strcpy($$.buf, " + ");
    strcpy($$.buf, $3.buf);
  }
  
| exp MINUSnumber term
   {
      $$.val = $1.val - $3.val;
      strcpy($$.buf, $1.buf);
      strcpy($$.buf, " - ");
      strcpy($$.buf, $3.buf);
   }
  
| MINUSnumber term
  {
    $$.val = $2.val * -1;
    sprintf($$.buf, "%d", $$.val);
  }
  ;

term: factor
  {
    $$.val = $1.val;
    strcpy($$.buf, $1.buf);
  }
  
| term TIMESnumber factor
  {
    $$.val = $1.val * $3.val;
    strcpy($$.buf, $1.buf);
    strcpy($$.buf, " * ");
    strcpy($$.buf, $3.buf);
  }
  
| term DIVnumber factor
  {
    if ($3.val == 0)
    {
      printf("error: dividing by zero on line %d.\n", yyline);
      exit(0);
    }
    
    else
    {
      $$.val = $1.val / $3.val;
    }
    
    strcpy($$.buf, $1.buf);
    strcpy($$.buf, " / ");
    strcpy($$.buf, $3.buf);
  }
  ;

factor: ICONSTnumber
   {
      $$.val = $1;
      sprintf($$.buf, "%i", $$.val);
   }

| IDnumber
  {
    char *temp = string_table + $1;
    int in = Valid(temp);
    if (in != -1)
    {
      if (data_table[in].full == 1)
      {
         $$.val = data_table[in].val;
      }
      
      else
      {
         printf("uninitiated variable on line %d\n", yyline);
         exit(0);
      }
    }

    else
    {
       printf("undeclared variable on line %d\n", yyline);
       exit(0);
    }
    strcpy($$.buf, temp);

   }
  
| LPARENnumber exp RPARENnumber
  {
    $$.val = $2.val;
    strcpy($$.buf, "(");
    strcpy($$.buf, $2.buf);
    strcpy($$.buf, ")");
  }
  ;

%%

#include <stdio.h>
#include <string.h>

int yywrap()
{
   if(feof(stdin)) 
      return 1;
   else
      return 0;
}

int Valid(char t[])
{
  int i;
  int temp = 0;
  for(i = 0; i < table_index; i++)
  {
    if (strcmp(t, data_table[i].buf)==0)
    {
      temp = i;
      break;
    }
  }
  return (temp - 1);
}

void print_header()
{
  if ((outfile = fopen("mya.cpp", "w")) == NULL)
  {
    printf("Can't open file mya.cpp.\n");
  }
  fprintf(outfile, "#include <iostream>\n");
  fprintf(outfile, "#include <fstream>\n");
  fprintf(outfile, "#include <stdio.h>\n");
  fprintf(outfile, "using namespace std;\n");
  fprintf(outfile, "\nint main()\n");
  fprintf(outfile, "{\n");
} 

void print_end()
{
   fprintf(outfile, "}\n");
   fclose(outfile);
}

void print_exp(const char *s)
{
   fprintf(outfile, "  cout << %s << \"\\n\";\n", s);
}

void yyerror(const char *error)
{
   printf("line %d: syntax error\n", yyline);
}

int main()
{
  if (!yyparse())
    printf("accept\n");
  else 
    printf("reject\n");
}  
