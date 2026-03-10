/*
Author: Margret Steele
Class: CS256
Date: 9/9/2012
Assignment: 2
Purpose: A simple MFPL lexical analyzer

Running instructions: flex this file, then compile the outputed lex.yy.c file
with bison. G++ the bison'd file and then use that outputed file to run. Can 
be given an input file or command line input.

i.e. flex steelem.l
bison steelem.y
g++ steelem.tab.c -o steelem_parser
steelem_parser < inputFileName

Grammer is:

<expr> ? intconst | strconst | ident | ( <parenthesized_expr> )
<parenthesized_expr> ? <arithmetic_expr> | <if_expr> | <let_expr>
| <lambda_expr> | <print_expr> | <input_expr>
| <expr_list>
<arithmetic_expr> ? <op> <expr> <expr>
<if_expr> ? if <expr> <expr> <expr>
<let_expr> ? let ( <id_expr_list> ) <expr>
<id_expr_list> ? e | <id_expr_list> ( ident <expr> )
<lambda_expr> ? lambda ( <id_list> ) <expr>
<id_list> ? e | <id_list> ident
<print_expr> ? print <expr>
<input_expr> ? input
<expr_list> ? <expr> <expr_list> | <expr>
<op> ? + | - | * | /


*/
%{

#include <stdio.h>

int numLines = 0;

void printRule(const char *lhs, const char *rhs);
int yyerror(const char *s);
void printTokenInfo(const char* tokenType, const char* lexeme);

extern "C" {
    int yyparse(void);
    int yylex(void);
    int yywrap() { return 1; }}

%}
	
/* Token declarations */
%token T_LET T_LAMBDA T_INPUT T_PRINT T_IF T_LPAREN T_RPAREN T_ADD 
T_MULT T_DIV T_SUB T_IDENT T_INTCONST T_STRCONST T_COMMENT T_UNKNOWN

/* Starting point */
%start N_START

/* Translation rules */
%%
N_START : N_EXPR
    {
    printRule ("START", "EXPR");
    printf("\n-- Completed parsing --\n\n");
    return 0;
    };
	
N_EXPR : T_INTCONST
    {
    printRule("EXPR", "INTCONST");
    }
    | T_STRCONST
    {
    printRule("EXPR", "STRCONST");
    }
    | T_IDENT
    {
    printRule("EXPR", "IDENT");
    }
	| T_LPAREN N_PARENEXPR T_RPAREN
	{
	printRule( "EXPR", "( PARENTHESIZED_EXPR )");
	};
	
N_PARENEXPR : N_ATRITHMATIC_EXPR
    {
	printRule("PARENTHESIZED_EXPR", "ARITHMETIC_EXPR");
	}
	| N_IF_EXPR
	{
	printRule("PARENTHESIZED_EXPR", "IF_EXPR");
	}
	| N_LET_EXPR
	{
	printRule("PARENTHESIZED_EXPR", "LET_EXPR");
	}
	| N_LAMBDA_EXPR
	{
	printRule("PARENTHESIZED_EXPR", "LAMBDA_EXPR");
	}
	| N_PRINT_EXPR
	{
	printRule("PARENTHESIZED_EXPR", "PRINT_EXPR");
	}
	| N_INPUT_EXPR
	{
	printRule("PARENTHESIZED_EXPR", "INPUT_EXPR");
	}
	| N_EXPR_LIST
	{
	printRule("PARENTHESIZED_EXPR", "EXPR_LIST");
	};
	
N_ATRITHMATIC_EXPR : N_OP N_EXPR N_EXPR
    {
	printRule( "ARITHMETIC_EXPR", "OP EXPR EXPR");
	};
	
N_IF_EXPR : T_IF N_EXPR N_EXPR N_EXPR
    {
	printRule( "IF_EXPR", "if EXPR EXPR EXPR");
	};
	
N_LET_EXPR : T_LET T_LPAREN N_ID_EXPR_LIST T_RPAREN N_EXPR 
    {
	printRule("LET_EXPR", "let ( ID_EXPR_LIST ) EXPR");
    };
	
N_ID_EXPR_LIST : /* epsilon */
    {
	  printRule("ID_EXPR_LIST", "epsilon");
	}
	| N_ID_EXPR_LIST T_LPAREN T_IDENT N_EXPR T_RPAREN
	{
	printRule( "ID_EXPR_LIST", "ID_EXPR_LIST ( ident EXPR )");
	};
	
N_LAMBDA_EXPR : T_LAMBDA T_LPAREN N_ID_LIST T_RPAREN N_EXPR
   {
   printRule("LAMBDA_EXPR", "lambda ( ID_LIST ) EXPR");
   };
   
N_ID_LIST : /* epsilon */
    {
	  printRule("ID_LIST", "epsilon");
	}
	| N_ID_LIST T_IDENT
	{
	printRule("ID_LIST", "ID_LIST ident");
	};
	
N_PRINT_EXPR : T_PRINT N_EXPR
    {
	printRule("PRINT_EXPR", "print EXPR");
    };
	
N_INPUT_EXPR : T_INPUT
    {
	printRule("INPUT_EXPR", "input");
	};
	
N_EXPR_LIST : N_EXPR N_EXPR_LIST
    {
	printRule("EXPR_LIST", "EXPR EXPR_LIST");
	}
	| N_EXPR
	{
	printRule("EXPR_LIST", "EXPR");
	};
	
N_OP : T_ADD
    {
	printRule("OP", "+");
	}
	| T_SUB
	{
	printRule("OP", "-");
	}
	| T_MULT
	{
	printRule("OP", "*");
	}
	| T_DIV
	{
	printRule("OP", "/");
	};

%%

#include "lex.yy.c"
extern FILE *yyin;

void printRule(const char *lhs, const char *rhs) {
  printf("%s -> %s\n", lhs, rhs);
  return;
}

int yyerror(const char *s) {
  printf("%s\n", s);
  return(1);
}

void printTokenInfo(const char* tokenType, const char* lexeme) {
  printf("TOKEN: %s  LEXEME: %s\n", tokenType, lexeme);
}

int main() {
  do{
       yyparse();
    } while (!feof(yyin));
    printf("%d lines processed\n", numLines);
    return 0;
}