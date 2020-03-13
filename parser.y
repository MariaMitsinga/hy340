%{
	#include <stdio.h>
	int yyerror (char* yaccProvidedMessage);
	int alpha_yylex(void);
	
	extern int alphalineno;
	extern char * alphatext;
	extern FILE * alphain;
	
%}

%start program

%defines

%token id
%token NUMBER
%token FLOAT		
%token STRING			
%token NEWLINE			
%token NEWTAB			
%token IF              
%token ELSE            
%token WHILE           
%token FOR            
%token FUNCTION       
%token RETURN          
%token BREAK          
%token CONTINUE        
%token AND     
%token NOT             
%token OR          
%token LOCAL      
%token TRUE       
%token FALSE         
%token NIL         
%token SPACE		
%token EQUAL		
%token PLUS		
%token MINUS		
%token MULTIPLE	
%token FORWARD_SLASH	
%token BACKWARD_SLASH	
%token PERCENT		
%token DOUBLE_EQUAL	
%token NOT_EQUAL	
%token DOUBLE_PLUS	
%token DOUBLE_MINUS	
%token GREATER		
%token LESS	
%token GREATER_EQUAL	
%token LESS_EQUAL	
%token LEFT_CURLY_BRACKET	
%token RIGHT_CURLY_BRACKET     
%token LEFT_SQUARE_BRACKET	
%token RIGHT_SQUARE_BRACKET
%token LEFT_PARENTHESES	
%token RIGHT_PARENTHESES	
%token SEMI_COLON		
%token COMMA		
%token COLON		
%token NAMESPACE_ALIAS_QUALIFIER 
%token DOT			
%token DOUBLE_DOT	
%token LINE_COMMENT 	
%token MULTI_COMMENT 	
%token CARRIAGE_RETURN	
%token OTHER


%union
{
	char* strVal;
	int intVal;
	double dbVal;
}

%%
program:	exp{;}
			|	{;}
			;

exp:	exp '+' exp 
		;

%%


int yyerror (char* yaccProvidedMessage)
{
	fprintf(stderr, "%s: at line %d, before token: '%s'\n", yaccProvidedMessage, alphalineno, alphatext);
}

int main(int argc, char** argv)
{
	if(argc > 1)
	{
		if(!(alphain = fopen(argv[1],"r")))
		{
			fprintf(stderr,"Cannot read file: %s\n",argv[1]);
			return 0;
		}
	}
	else 
	{
		fprintf("Give an input from here\n");
		alphain=stdin;	
	}
	yyparse();
	return 1;
}









