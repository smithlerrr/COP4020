%{
#include "connector.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yyline, yycolumn;
typedef struct{
	char* word;
	int num;
} wordentry;
wordentry wordtable [1000];
int numwords = 0;
%}
%union{
	int intval;
	char* wordval;
	wordchunk package;
}
%token 	SEMInumber 				
%token 	LPARENnumber 			
%token 	<intval>ICONSTnumber 			
%token 	BEGINnumber 				
%token 	PROGRAMnumber 							
%token 	MINUSnumber 				
%token 	TIMESnumber 				
%token 	VARnumber 				
%token 	INTnumber			
%token 	COMMAnumber 			
%token 	RPARENnumber 			
%token 	<wordval>IDnumber 					
%token 	ENDnumber 				
%token 	ISnumber 				
%token 	PLUSnumber 				
%token 	DIVnumber 				
%token 	PRINTnumber 				
%token 	EQnumber 		
%type 	<package>	declaration
%type 	<package>	id
%type 	<package>	compStatement
%type 	<package>	statement
%type 	<package>	statements
%type 	<package>	exp
%type 	<package>	term
%type 	<package>	terms
%type 	<package>	factor
%type 	<package>	factors	
%start program
%%
	program 		: 	PROGRAMnumber IDnumber ISnumber compStatement{
							FILE * outfile = fopen("mya.cpp", "w");
							fprintf(outfile,"#include <iostream>\nusing namespace std;\n int main()\n{\n%s\n}\n", $4.wordfile);
							fclose(outfile);
						}
	declaration	:	VARnumber id{
							// printf("declaration\n");
							$$.wordfile = malloc(strlen($2.wordfile) + 30);
							strcpy($$.wordfile, "int ");
							strcat($$.wordfile, $2.wordfile);
							$$.wordfile = $2.wordfile;
						}
	id 				:	IDnumber{
							// printf("id 1\n");
							$$.wordfile = $1;
							// strcpy($$.wordfile, $1.wordfile);
						}
					|	IDnumber COMMAnumber id{
							// printf("id 2\n");
							$$.wordfile = malloc(strlen($1) + 30);
							strcpy($$.wordfile, $1);
							strcat($$.wordfile, ", ");
							strcat($$.wordfile, $3.wordfile);
						}
	compStatement:	BEGINnumber statements ENDnumber{
							// printf("comeStatement\n");
							// $$.wordfile = malloc(strlen($2.wordfile) + 3);
							// strcpy($$.wordfile, "{\n");
							// strcat($$.wordfile, $2.wordfile);
							// strcat($$.wordfile, "\n}\n");
							$$.wordfile = $2.wordfile;
						}
	statement 		:	IDnumber EQnumber exp{
							printf("%s EQ %d\n", $1, $3.numwords);
							$$.wordfile = malloc(strlen($3.wordfile) + 30);
							strcpy($$.wordfile, $1);
							strcat($$.wordfile, " = ");
							strcat($$.wordfile, $3.wordfile);
							$$.numwords = $3.numwords;
							// $$.wordfile = $1;
						}
					|	PRINTnumber exp{
							// printf("statement 2\n");
							$$.wordfile = malloc(strlen($2.wordfile) + 20);
							strcpy($$.wordfile, "cout << ");
							strcat($$.wordfile, $2.wordfile);
							strcat($$.wordfile, " << endl;");
							$$.numwords = $2.numwords;
							printf("%d\n", $$.numwords);
						}
					|	declaration{
							// printf("statement 3\n");
							$$.wordfile = $1.wordfile;
							$$.numwords = $1.numwords;
						}
	statements 	:	statement{
							// printf("statementS 1\n");
							$$.wordfile = $1.wordfile;
							$$.numwords = $1.numwords;
						}
					|	statement SEMInumber statements{
							// printf("statementS 2\n");
							$$.wordfile = malloc(strlen($1.wordfile) + 30);
							strcpy($$.wordfile, $1.wordfile);
							strcat($$.wordfile, "; ");
							strcat($$.wordfile, $3.wordfile);
							$$.numwords = $1.numwords;
							// $$.wordfile = $1.wordfile;
						}
	
	exp			:	MINUSnumber term{
							printf("MINUSnum %d\n", $2.numwords);
							$$.wordfile = malloc(strlen($2.wordfile) + 30);
							strcpy($$.wordfile, "-");
							strcat($$.wordfile, $2.wordfile);
							$$.numwords = (0 - $2.numwords);
							// $$.wordfile = $2.wordfile;
						}
					|	term{
							// printf("exp 2\n");
							$$.wordfile = $1.wordfile;
							$$.numwords = $1.numwords;
						}
	term			:	terms{
							// printf("term 1\n");
							$$.wordfile = $1.wordfile;
							$$.numwords = $1.numwords;
						}
					|	terms PLUSnumber term{
							printf("%d PLUS %d\n", $1.numwords, $3.numwords);
							$$.wordfile = malloc(strlen($1.wordfile) + 30);
							strcpy($$.wordfile, $1.wordfile);
							strcat($$.wordfile, " + ");
							strcat($$.wordfile, $3.wordfile);
							$$.numwords = $1.numwords + $3.numwords;
							// $$.wordfile = $1.wordfile;
						}
					|	terms MINUSnumber term{
							printf("%d MINUS %d\n", $1.numwords, $3.numwords);
							$$.wordfile = malloc(strlen($1.wordfile) + 30);
							strcpy($$.wordfile, $1.wordfile);
							strcat($$.wordfile, " - ");
							strcat($$.wordfile, $3.wordfile);
							$$.numwords = $1.numwords - $3.numwords;
						}
	terms			:	factor{
							// printf("termS 1\n");
							$$.wordfile = $1.wordfile;
							$$.numwords = $1.numwords;
						}
	factor 			:	factors{
							// printf("factor 1\n");
							$$.wordfile = $1.wordfile;
							$$.numwords = $1.numwords;
						}
					|	factors TIMESnumber factor{
							printf("%d TIMES %d\n", $1.numwords, $3.numwords);
							$$.wordfile = malloc(strlen($1.wordfile) + 30);
							strcpy($$.wordfile, $1.wordfile);
							strcat($$.wordfile, " * ");
							strcat($$.wordfile, $3.wordfile);
							$$.numwords = ($1.numwords*$3.numwords);
							// $$.wordfile = $1.wordfile;
						}
					| 	factors DIVnumber factor{
							printf("%d DIV %d\n", $1.numwords, $3.numwords);
							// $$.wordfile = $1.wordfile;
							//INCLUDE /0 CHECKING
							$$.wordfile = malloc(strlen($1.wordfile) + 30);
							strcpy($$.wordfile, $1.wordfile);
							strcat($$.wordfile, " / ");
							strcat($$.wordfile, $3.wordfile);
							$$.numwords = ($1.numwords/$3.numwords);
						}
	factors			:	ICONSTnumber{
							// printf("factorS 1\n");
							$$.wordfile = convertInt($1);
							$$.numwords = $1;
							//$$.intval = $1;
						}
					|	IDnumber{
							// printf("factorS 2\n");
							$$.wordfile = malloc(strlen($1)+30);
							strcpy($$.wordfile, $1);
						}
					|	LPARENnumber exp RPARENnumber{
							// printf("factorS 3\n");
							$$.wordfile = malloc(strlen($2.wordfile) + 40);
							$$.numwords = $2.numwords;
							strcpy($$.wordfile, "( ");
							strcat($$.wordfile, $2.wordfile);
							strcat($$.wordfile, " )");
						}
%%
void yyerror(char * s)
{
    printf("yyerror: Error at line %d\n", yyline);
}
int main()
{
   if(yyparse() == 0)
      printf("accept\n");
   else
      printf("reject\n");
}
char* convertInt(int num) {
	char *mem = malloc(100);
	sprintf(mem, "%d", num);
	return mem;
}