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

%right EQUAL
%left OR
%left AND
%nonassoc DOUBLE_EQUAL NOT_EQUAL
%nonassoc GREATER GREATER_EQUAL LESS LESS_EQUAL
%left PLUS MINUS
%left MULTIPLE FORWARD_SLASH PERCENT
%right NOT DOUBLE_PLUS DOUBLE_MINUS
%left DOT DOUBLE_DOT
%left LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET
%left LEFT_PARENTHESES RIGHT_PARENTHESES


%union
{
	char* strVal;
	int intVal;
	double dbVal;
}

%%

program:	stmt
		| 
		;

stmt: 	expr SEMI_COLON
	| ifstmt
	| whilestmt
	| forstmt
	| returnstmt
	| BREAK SEMI_COLON
	| CONTINUE SEMI_COLON
	| block
	| funcdef
	| ;

expr:	assignexpr
	| expr op expr
	| term
	;

op:	PLUS | MINUS | MULTIPLE  | FORWARD_SLASH | PERCENT | GREATER  | GREATER_EQUAL | LESS  | LESS_EQUAL | DOUBLE_EQUAL | NOT_EQUAL | AND | OR
	;

term:	LEFT_PARENTHESES expr RIGHT_PARENTHESES
	| MINUS expr
	| NOT expr
	| lvalue
	| lvalue DOUBLE_PLUS
	| DOUBLE_MINUS lvalue
	| lvalue DOUBLE_MINUS
	| primary
	;

assginexpr:	lvalue EQUAL expr
		;

primary:	lvalue
		| call
		| objectdef
		| LEFT_PARENTHESES funcdef RIGHT_PARENTHESES
		| const
		;
	
lvalue:		id
		| LOCAL id
		| NAMESPACE_ALIAS_QUALIFIER id
		| member
		;

member:		lvalue DOT id
		| lvalue LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET
		| call DOT id
		| call LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET
		;

call:		call LEFT_PARENTHESES elist RIGHT_PARENTHESES
		| lvalue callsuffix
		| LEFT_PARENTHESES funcdef RIGHT_PARENTHESES LEFT_PARENTHESES elist RIGHT_PARENTHESES
		;

callsuffix:	normcall
		| methodcall
		;

normcall:	LEFT_PARENTHESES elist RIGHT_PARENTHESES
methodcall:	DOUBLE_DOT id LEFT_PARENTHESES elist RIGHT_PARENTHESES // equivalent to lvalue.id(lvalue, elist)



objectdef:	LEFT_SQUARE_BRACKET elist
		| indexed RIGHT_SQUARE_BRACKET



indexedelem: 	LEFT_CURLY_BRACKET expr COLON expr RIGHT_CURLY_BRACKET

block: 		LEFT_CURLY_BRACKET stmt RIGHT_CURLY_BRACKET
		| LEFT_CURLY_BRACKET block1 RIGHT_CURLY_BRACKET
		;

block1:		stmt
		| stmt block1
		;

funcdef: 	function LEFT_SQUARE_BRACKET id RIGHT_SQUARE_BRACKET LEFT_PARENTHESES idlist RIGHT_PARENTHESES block

const: 		NUMBER 
		| STRING
		| NIL 
		| TRUE 
		| FALSE
		;

idlist:		id
		| idcomm id
		;

idcomm:		COMMA id
		| COMMA id idcomm
		;		

ifstmt:		IF LEFT_PARENTHESES expr RIGHT_PARENTHESES stmt
		| IF LEFT_PARENTHESES expr RIGHT_PARENTHESES stmt ELSE stmt
		;

whilestmt:	WHILE LEFT_PARENTHESES expr RIGHT_PARENTHESES stmt
		;

forstmt:	FOR LEFT_PARENTHESES elist SEMI_COLON expr SEMI_COLON elist RIGHT_PARENTHESES stmt

returnstmt:	RETURN expr SEMI_COLON
		| RETURN SEMI_COLON
		;

%%

int yyerror (char* yaccProvidedMessage)
{
	fprintf(stderr, "%s: at line %d, before token: '%s'\n", yaccProvidedMessage, yylineno, yytext);
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
