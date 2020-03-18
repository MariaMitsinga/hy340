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

program:	stamt {fprintf(yyout," program ==> stmt \n");}
		;

stamt:		stmt stamt {fprintf(yyout," stamt ==> stmt stamt\n");}
		| /* empty*/ {fprintf(yyout,"stamt ==> empty \n");}
		;

stmt:		expr SEMI_COLON {fprintf(yyout," stmt ==> expr ;\n");}
		|ifstmt	{fprintf(yyout," stmt ==> ifstmt ;\n");}
		|whilestmt {fprintf(yyout," stmt ==> whilestmt ;\n");}
		|forstmt {fprintf(yyout," stmt ==> forstmt ;\n");}
		|returnstmt {fprintf(yyout," stmt ==> returnstmt ;\n");}
		|BREAK SEMI_COLON {fprintf(yyout," stmt ==> break; \n");}
		|CONTINUE SEMI_COLON {fprintf(yyout," stmt ==> break; \n");}
		|block
		|funcdef
		;

expr:		assgnexpr {fprintf(yyout," expr ==> assgnexpr \n");}
		|expr PLUS expr {fprintf(yyout," expr ==> expr + expr \n");}
		|expr MINUS expr {fprintf(yyout," expr ==> expr - expr \n");}	
		|expr MULTIPLE expr {fprintf(yyout," expr ==> expr * expr \n");}
		|expr FORWARD_SLASH expr {fprintf(yyout," expr ==> expr / expr \n");}
		|expr PERCENT expr {fprintf(yyout," expr ==> expr % expr \n");}
		|expr GREATER expr {fprintf(yyout," expr ==> expr > expr \n");}
		|expr GREATER_EQUAL expr {fprintf(yyout," expr ==> expr >= expr \n");}
		|expr LESS  expr {fprintf(yyout," expr ==> expr < expr \n");}
		|expr LESS_EQUAL expr {fprintf(yyout," expr ==> expr <= expr \n");}
		|expr DOUBLE_EQUAL expr {fprintf(yyout," expr ==> expr == expr \n");}
		|expr NOT_EQUAL expr {fprintf(yyout," expr ==> expr != expr \n");}
		|expr AND expr {fprintf(yyout," expr ==> expr && expr \n");}
		|expr OR expr {fprintf(yyout," expr ==> expr || expr \n");}
		| term {fprintf(yyout," expr ==> term \n");}
		;

term:		LEFT_PARENTHESES expr RIGHT_PARENTHESES {fprintf(yyout," term ==> (expr) \n");}
		| MINUS expr {fprintf(yyout," term ==> -expr \n");}
		| NOT expr {fprintf(yyout," term ==> !expr \n");}
		| DOUBLE_PLUS lvalue 	{fprintf(yyout," term ==> ++lvalue \n");}
		| lvalue DOUBLE_PLUS	{fprintf(yyout," term ==> lvalue++ \n");}
		| DOUBLE_MINUS lvalue	{fprintf(yyout," term ==> --lvalue \n");}
		| lvalue DOUBLE_MINUS	{fprintf(yyout," term ==> lvalue-- \n");}
		| primary {fprintf(yyout," term ==> primary \n");}
		;

assgnexpr:	lvalue EQUAL expr {fprintf(yyout," assgnexpr ==> Ivalue=expr \n");}
		;

primary:  	lvalue	{fprintf(yyout," primary ==> Ivalue \n");}
		| call {fprintf(yyout," primary ==> call \n");}
		| objectdef {fprintf(yyout," primary ==> objectdef \n");}
		| LEFT_PARENTHESES funcdef RIGHT_PARENTHESES {fprintf(yyout," primary ==> (funcdef) \n");}
		| const {fprintf(yyout," primary ==> const \n");}
	 	;

lvalue:		id	{fprintf(yyout," Ivalue ==> id \n");}
		| LOCAL id	{fprintf(yyout," Ivalue ==> local \n");}
		| NAMESPACE_ALIAS_QUALIFIER id	{fprintf(yyout," Ivalue ==> ::id \n");}
		| member	{fprintf(yyout," Ivalue ==> member \n");}
		;

member:		lvalue DOT id	{fprintf(yyout," Member ==> .id \n");}
		| lvalue LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET	{fprintf(yyout," Member ==> [expr] \n");}
		| call DOT id	{fprintf(yyout," Member ==> call.id \n");}
		| call LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET {fprintf(yyout," Member ==> call[expr] \n");}
		;

call:		call LEFT_PARENTHESES elist RIGHT_PARENTHESES	{fprintf(yyout," CALL ==> call(elist) \n");}
		| lvalue callsuffix	{fprintf(yyout," call ==> ivalue callsuffix \n");} 
		| LEFT_PARENTHESES funcdef RIGHT_PARENTHESES LEFT_PARENTHESES elist RIGHT_PARENTHESES {fprintf(yyout," call ==> (funcdef)(elist) \n");}
		;

callsuffix:	normcall	{fprintf(yyout," callsuffix ==> normcall \n");}
		| methodcall	{fprintf(yyout," callsuffix ==> methodcall \n");}
		;

normcall:	LEFT_PARENTHESES elist RIGHT_PARENTHESES {fprintf(yyout," normcall ==> (elist) \n");}
		;	

methodcall:	DOUBLE_DOT id LEFT_PARENTHESES elist RIGHT_PARENTHESES {fprintf(yyout," methodcall ==> ..id(elist) \n");}
		;

elist:	 	expr elist1	{fprintf(yyout," elist ==> expr elist1 \n");}
		| /* empty */	{fprintf(yyout," elist ==>  \n");}
		;

elist1:		COMMA expr elist1	{fprintf(yyout," elist ==> , expr elist1 \n");}
		| /* empty */	{fprintf(yyout," elist ==>  \n");}
		;

objectdef:	LEFT_SQUARE_BRACKET elist RIGHT_SQUARE_BRACKET	{fprintf(yyout," objectdef ==> [elist] \n");}
		| LEFT_SQUARE_BRACKET indexed RIGHT_SQUARE_BRACKET {fprintf(yyout," objectdef ==> [indexed] \n");}
		;

indexed:	indexedelem indexed1	{fprintf(yyout," indexed ==> indexedelem indexed1 \n");}
		;

indexed1: 	COMMA indexedelem indexed1	{fprintf(yyout," indexed ==> indexedelem indexed1 \n");}
		| /* empty */	{fprintf(yyout," indexed ==>   \n");}
		;

indexedelem: 	LEFT_CURLY_BRACKET expr COLON expr RIGHT_CURLY_BRACKET	{fprintf(yyout," indexedelem ==> { expr : expr } \n");}
		;

block:		LEFT_CURLY_BRACKET stamt RIGHT_CURLY_BRACKET {fprintf(yyout," block ==> { [stmt] } \n");}
		;

funcdef: 	FUNCTION LEFT_PARENTHESES idlist RIGHT_PARENTHESES block	{fprintf(yyout," funcdef ==> function(){} \n");}
		|FUNCTION id LEFT_PARENTHESES idlist RIGHT_PARENTHESES block	{fprintf(yyout," funcdef ==> function id(){} \n");}
		;

const:		NUMBER {fprintf(yyout," const ==> number \n");}
		| STRING {fprintf(yyout," const ==> string \n");}
		| NIL {fprintf(yyout," const ==> nil \n");}
		| TRUE {fprintf(yyout," const ==> true \n");}
		| FALSE {fprintf(yyout," const ==> false \n");}
		| FLOAT {fprintf(yyout," const ==> float \n");}
		;

idlist:		id idlist1	{fprintf(yyout, "id,id* ==> idlist;\n");}
		| /* empty */	{fprintf(yyout, "id,id* ==> idlist;\n");}
		;	

idlist1:	COMMA id idlist1	{fprintf(yyout, "id,id* ==> idlist;\n");}
		| /* empty */	{fprintf(yyout, "id,id* ==> idlist;\n");}
		;

ifstmt:		IF LEFT_PARENTHESES expr RIGHT_PARENTHESES stmt			{fprintf(yyout, "ifstmt ==> IF THEN;\n");}
		| IF LEFT_PARENTHESES expr RIGHT_PARENTHESES stmt ELSE stmt	{fprintf(yyout, "ifstmt ==> IF THEN ELSE;\n");}
		;

whilestmt :	WHILE LEFT_PARENTHESES expr RIGHT_PARENTHESES stmt {fprintf(yyout," whilestmt==> while(expr) stmt \n");}
		;

forstmt:	FOR LEFT_PARENTHESES elist SEMI_COLON expr SEMI_COLON elist RIGHT_PARENTHESES stmt {fprintf(yyout," forstmt ==> (elist;expr;elist)stmt \n");}
		;

returnstmt:	RETURN SEMI_COLON {fprintf(yyout,"returnstmt ==> return ;\n");}
		| RETURN expr SEMI_COLON {fprintf(yyout,"returnstmt ==> return expr;\n");}
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
