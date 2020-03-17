%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <assert.h>	
	
	int yyerror (char* yaccProvidedMessage);
	int yylex (void);
	
	extern int yylineno;
	extern char * yyval;
	extern char * yytext;
	extern FILE * yyin;
	extern FILE * yyout;
%}

%start program


%token	id
%token	NUMBER
%token	FLOAT		
%token	STRING			
%token	NEWLINE
%token	NEWTAB
%token	IF              
%token	ELSE            
%token	WHILE           
%token	FOR            
%token	FUNCTION       
%token	RETURN          
%token	BREAK          
%token	CONTINUE        
%token	AND     
%token	NOT             
%token	OR          
%token	LOCAL      
%token	TRUE       
%token	FALSE         
%token	NIL         
%token 	SPACE
%token	EQUAL
%token	PLUS		
%token	MINUS		
%token	MULTIPLE	
%token	FORWARD_SLASH	
%token	BACKWARD_SLASH	
%token	PERCENT		
%token	DOUBLE_EQUAL	
%token	NOT_EQUAL	
%token	DOUBLE_PLUS	
%token	DOUBLE_MINUS	
%token	GREATER		
%token	LESS	
%token	GREATER_EQUAL	
%token	LESS_EQUAL	
%token	LEFT_CURLY_BRACKET	
%token	RIGHT_CURLY_BRACKET     
%token	LEFT_SQUARE_BRACKET	
%token	RIGHT_SQUARE_BRACKET
%token	LEFT_PARENTHESES	
%token	RIGHT_PARENTHESES	
%token	SEMI_COLON		
%token	COMMA		
%token	COLON		
%token	NAMESPACE_ALIAS_QUALIFIER 
%token	DOT			
%token	DOUBLE_DOT	
%token	LINE_COMMENT 	
%token	MULTI_COMMENT 	
%token	CARRIAGE_RETURN	
%token	OTHER

%right	EQUAL
%left	OR
%left	AND
%nonassoc	DOUBLE_EQUAL NOT_EQUAL
%nonassoc	GREATER GREATER_EQUAL LESS LESS_EQUAL
%left	PLUS MINUS
%left	MULTIPLE FORWARD_SLASH PERCENT
%right	NOT DOUBLE_PLUS DOUBLE_MINUS
%left	DOT DOUBLE_DOT
%left	LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET
%left	LEFT_PARENTHESES RIGHT_PARENTHESES


%union
{
	char* strVal;
	int intVal;
	double dbVal;
}

%%


indexed:	indexedelem indexed1	{fprintf(yyout, "indexed\n");}
		| /* empty */		{fprintf(yyout, "indexed\n");}
		;

indexed1: 	COMMA indexedelem indexed1	{fprintf(yyout, "indexed\n");}
		| /* empty */	{fprintf(yyout, "indexed\n");}
		;

elist:	 	expr elist1	{fprintf(yyout, "elist\n");}
		| /* empty */	{fprintf(yyout, "elist\n");}
		;

elist1:		COMMA expr elist1	{fprintf(yyout, "elist\n");}
		| /* empty */	{fprintf(yyout, "elist\n");}
		;

idlist:		id idlist1	{fprintf(yyout, "id,id* ==> idlist;\n");}
		| /* empty */	{fprintf(yyout, "id,id* ==> idlist;\n");}
		;	

idlist1:	COMMA id idlist1	{fprintf(yyout, "id,id* ==> idlist;\n");}
		| /* empty */	{fprintf(yyout, "id,id* ==> idlist;\n");}
		;

%%

int yyerror (char* yaccProvidedMessage)
{
	fprintf(stderr, "%s: at line %d, before token: '%s'\n", yaccProvidedMessage, yylineno, yytext);
	fprintf(stderr, "INPUT NOT VALID\n");
}

int main(int argc, char** argv)
{

	if (argc == 3){
		if( !(yyin = fopen(argv[1], "r")) ) {
			fprintf(stderr, "Cannot Open File: %s\n", argv[1]);
			yyin = stdin;
		}
		if(!(yyout = fopen(argv[2], "w")) )
		{
			fprintf(stderr, "Cannot Open File: %s\n", argv[2]);
			yyout = stdout;
		}
	}
	else if (argc == 2){
		if( !(yyin = fopen(argv[1], "r")) ) {
			fprintf(stderr, "Cannot Open File: %s\n", argv[1]);
			yyin = stdin;
		}
	}
	else{
		fprintf(stderr, "WTF...Give mama some arguments ;P \n");
		return 0;
	}
	yyparse();
	
	
	return 0;
}
