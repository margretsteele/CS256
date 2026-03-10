/*
Authors: Margret Steele and Thomas Reese
Class: CS256
Date: 10/14/2012
Assignment: 4
Purpose: A simple MFPL lexical and semantic analyzer

Running instructions: flex this file, then compile the outputed lex.yy.c file
with bison. G++ the bison'd file and then use that outputed file to run. Can 
be given an input file or command line input.

i.e. flex steelereese.l
bison steelereese.y
g++ steelereese.tab.c -o steelereese_parser
steelereese_parser < inputFileName

Grammar is:

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
#include <stack>
#include "SymbolTable.h"

int numLines = 1;
stack<SYMBOL_TABLE> scopeStack;

void printRule(const char *lhs, const char *rhs);
int yyerror(const char *s);
void printTokenInfo(const char* tokenType, const char* lexeme);
void endScope();
void beginScope();
bool findEntryInAnyScope(string theName);
int findEntryTypeInAnyScope(string theName);
int findEntryNumParamsInAnyScope(string theName);
int findEntryReturnTypeInAnyScope(string theName);
bool isIntCompatible(int type);
bool isStrCompatible(int type);
bool isFunctionCompatible(int type);


extern "C" {
    int yyparse(void);
    int yylex(void);
    int yywrap() { return 1; }}

%}

%union {
  char* text;
  TYPE_INFO typeInfo;
};
	
/* Token declarations */
%token T_LET T_LAMBDA T_INPUT T_PRINT T_IF T_LPAREN T_RPAREN T_ADD 
T_MULT T_DIV T_SUB T_IDENT T_INTCONST T_STRCONST T_COMMENT T_UNKNOWN

%type<text> T_IDENT
%type<typeInfo> N_EXPR N_IF_EXPR N_PARENEXPR 
N_ATRITHMATIC_EXPR N_PRINT_EXPR N_EXPR_LIST N_INPUT_EXPR N_LET_EXPR 
N_ID_EXPR_LIST N_LAMBDA_EXPR N_ID_LIST

/* Starting point */
%start N_START

/* Translation rules */
%%
N_START : N_EXPR
    {
    printRule ("START", "EXPR");
    printf("\n---- Completed parsing ----\n\n");
    return 0;
    };
	
N_EXPR : T_INTCONST
    {
		printRule("EXPR", "INTCONST");
		$$.type = INT; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
    }
    | T_STRCONST
    {
		printRule("EXPR", "STRCONST");
		$$.type = STR; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
    }
    | T_IDENT
    {
		printRule("EXPR", "ID");
		bool found = findEntryInAnyScope(string($1));
		if(!found)
		{
			printf("Line %d: Undefined identifier\n", numLines);
			exit(1);
		}
	
		$$.type = findEntryTypeInAnyScope(string($1));
		$$.numParams = findEntryNumParamsInAnyScope(string($1));
		$$.returnType = findEntryReturnTypeInAnyScope(string($1));
    }
	| T_LPAREN N_PARENEXPR T_RPAREN
	{
		printRule("EXPR", "( PARENTHESIZED_EXPR )");
		$$.type = $2.type; 
        $$.numParams = $2.numParams;
		$$.returnType = $2.returnType;
	};
	
N_PARENEXPR : N_ATRITHMATIC_EXPR
    {
		printRule("PARENTHESIZED_EXPR", "ARITHMETIC_EXPR");
		$$.type = $1.type;
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	}
	| N_IF_EXPR
	{
		printRule("PARENTHESIZED_EXPR", "IF_EXPR");
		$$.type = $1.type;
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	}
	| N_LET_EXPR
	{
		printRule("PARENTHESIZED_EXPR", "LET_EXPR");
		$$.type = $1.type;
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	}
	| N_LAMBDA_EXPR
	{
		printRule("PARENTHESIZED_EXPR", "LAMBDA_EXPR");
		$$.type = $1.type;
		$$.numParams = $1.numParams;
		$$.returnType = $1.returnType;
	}
	| N_PRINT_EXPR
	{
		printRule("PARENTHESIZED_EXPR", "PRINT_EXPR");
		$$.type = $1.type;
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	}
	| N_INPUT_EXPR
	{
		printRule("PARENTHESIZED_EXPR", "INPUT_EXPR");
		$$.type = $1.type;
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	}
	| N_EXPR_LIST
	{
		printRule("PARENTHESIZED_EXPR", "EXPR_LIST");
		$$.type = $1.type;
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	};
	
N_ATRITHMATIC_EXPR : N_OP N_EXPR N_EXPR
    {
		printRule( "ARITHMETIC_EXPR", "OP EXPR EXPR");
		if (! isIntCompatible($2.type)) 
		{
			yyerror("Arg 1 must be of type integer");
			return(1);
		}
		if (! isIntCompatible($3.type)) 
		{
			yyerror("Arg 2 must be of type integer");
			return(1);
		}
		$$.type = INT; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	};
	
N_IF_EXPR : T_IF N_EXPR N_EXPR N_EXPR
    {
		printRule( "IF_EXPR", "if EXPR EXPR EXPR");
		if (! isIntCompatible($2.type)) 
		{
			yyerror("Arg 1 must be of type integer");
			return(1);
		}
		if (! (isIntCompatible($3.type) || isStrCompatible($3.type))) 
		{
			yyerror("Arg 2 must be of type integer or string");
			return(1);
		}
		if (! (isIntCompatible($4.type) || isStrCompatible($4.type))) 
		{
			yyerror("Arg 3 must be of type integer or string");
			return(1);
		}
		$$.type = INT_or_STR; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	};
	
N_PRINT_EXPR : T_PRINT N_EXPR
    {
		printRule("PRINT_EXPR", "print EXPR");
		if (! (isIntCompatible($2.type) || isStrCompatible($2.type))) 
		{
			yyerror("Arg 1 must be of type integer or string");
			return(1);
		}
		$$.type = $2.type; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
    };
	
N_INPUT_EXPR : T_INPUT
    {
		printRule("INPUT_EXPR", "input");
		$$.type = INT_or_STR; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	};
	
N_EXPR_LIST : N_EXPR N_EXPR_LIST
    {
		printRule("EXPR_LIST", "EXPR EXPR_LIST");
		if (! (isIntCompatible($2.type) || isStrCompatible($2.type))) 
		{
			yyerror("Arg 2 must be of type integer or string");
			return(1);
		}
		if (isFunctionCompatible($1.type))
		{
            if( $2.length < $1.numParams)
            {
                yyerror("Too few parameters in function call");
                return(1);
            }
            else if( $2.length > $1.numParams)
            {
                yyerror("Too many parameters in function call");
                return(1);
            }   
        
            $$.type = $1.returnType;   
        }
        $$.numParams = NOT_APPLICABLE;
  		$$.returnType = NOT_APPLICABLE;
		$$.length = $2.length + 1;
	}
	| N_EXPR
	{
		printRule("EXPR_LIST", "EXPR");
		$$.type = INT_or_STR; 
		$$.numParams = NOT_APPLICABLE;
        $$.returnType = NOT_APPLICABLE;
		$$.length = $$.length + 1;
	};
	
N_LET_EXPR : T_LET T_LPAREN N_ID_EXPR_LIST T_RPAREN N_EXPR 
    {
		printRule("LET_EXPR", "let ( ID_EXPR_LIST ) EXPR");
		endScope();
		if (! (isIntCompatible($5.type) || isStrCompatible($5.type))) 
		{
			yyerror("Arg 2 must be of type integer or string");
			return(1);
		}
		$$.type = INT_or_STR; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
    };
	
N_ID_EXPR_LIST : /* epsilon */
    {
		printRule("ID_EXPR_LIST", "epsilon");
		$$.type = UNDEFINED; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	}
	| N_ID_EXPR_LIST T_LPAREN T_IDENT N_EXPR T_RPAREN
	{
		printRule( "ID_EXPR_LIST", "ID_EXPR_LIST ( ID EXPR )");
		SYMBOL_TABLE_ENTRY newSymbol = SYMBOL_TABLE_ENTRY( string($3).c_str(), $4.type, $4.numParams, $4.returnType ); 
		if( scopeStack.top().addEntry(newSymbol) )
		{
			printf("___Adding %s to symbol table\n", string($3).c_str()); 
		}
		else
		{
			if( scopeStack.top().findEntry( newSymbol.getName()) )
			{
				printf("___Adding %s to symbol table\n", string($3).c_str()); 
				printf("Line %d: Multiply defined identifier\n", numLines);
				exit(1);
			}
		}
		$$.type = UNDEFINED; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
	};
	
N_LAMBDA_EXPR : T_LAMBDA T_LPAREN N_ID_LIST T_RPAREN N_EXPR
   {
		printRule("LAMBDA_EXPR", "lambda ( ID_LIST ) EXPR");
		endScope();
		if (! (isIntCompatible($5.type) || isStrCompatible($5.type))) 
		{
			yyerror("Arg 2 must be of type integer or string");
			return(1);
		}
		$$.type = FUNCTION; 
		$$.numParams = $3.length;
		$$.returnType = $5.type;
   };
   
N_ID_LIST : /* epsilon */
    {
		printRule("ID_LIST", "epsilon");
		$$.type = UNDEFINED; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;
        $$.length = 0;
	}
	| N_ID_LIST T_IDENT
	{
		printRule("ID_LIST", "ID_LIST ID");
		SYMBOL_TABLE_ENTRY newSymbol = SYMBOL_TABLE_ENTRY( string($2).c_str(), INT, NOT_APPLICABLE, NOT_APPLICABLE );
		if( scopeStack.top().addEntry(newSymbol) )
		{
			printf("___Adding %s to symbol table\n", string($2).c_str()); 
		}
		else
		{
			if( scopeStack.top().findEntry( newSymbol.getName()) )
			{
				printf("___Adding %s to symbol table\n", string($2).c_str()); 
				printf("Line %d: Multiply defined identifier\n", numLines);
				exit(1);
			}
		}
		$$.type = UNDEFINED; 
		$$.numParams = NOT_APPLICABLE;
		$$.returnType = NOT_APPLICABLE;	
        $$.length = $1.length + 1;
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
  printf("Line %d: %s\n", numLines, s);
  return(1);
}

void printTokenInfo(const char* tokenType, const char* lexeme) {
  printf("TOKEN: %s  LEXEME: %s\n", tokenType, lexeme);
}

void beginScope() {
  scopeStack.push(SYMBOL_TABLE( ));
  printf("\n___Entering new scope...\n\n");
}

void endScope() {
  scopeStack.pop( );
  printf("\n___Exiting scope...\n\n");
}

bool findEntryInAnyScope(string theName) 
{
	if (scopeStack.empty( )) return(false);
	bool found = scopeStack.top( ).findEntry(theName);
	if (found) 
		return(true);
	else 
	{ // check in "next higher" scope
		SYMBOL_TABLE symbolTable = scopeStack.top( );
		scopeStack.pop( );
		found = findEntryInAnyScope(theName);
		scopeStack.push(symbolTable); // restore the stack
		return(found);
	}
}

int findEntryTypeInAnyScope(string theName) 
{
	if (scopeStack.empty( )) return(false);
	bool found = scopeStack.top( ).findEntry(theName);
	if (found) 
		return(scopeStack.top( ).findEntryType(theName));
	else 
	{ // check in "next higher" scope
		SYMBOL_TABLE symbolTable = scopeStack.top( );
		scopeStack.pop( );
		found = findEntryInAnyScope(theName);
		scopeStack.push(symbolTable); // restore the stack
		return(scopeStack.top( ).findEntryType(theName));
	}
}

int findEntryNumParamsInAnyScope(string theName) 
{
	if (scopeStack.empty( )) return(false);
	bool found = scopeStack.top( ).findEntry(theName);
	if (found) 
		return(scopeStack.top( ).findEntryNumParams(theName));
	else 
	{ // check in "next higher" scope
		SYMBOL_TABLE symbolTable = scopeStack.top( );
		scopeStack.pop( );
		found = findEntryInAnyScope(theName);
		scopeStack.push(symbolTable); // restore the stack
		return(scopeStack.top( ).findEntryNumParams(theName));
	}
}

int findEntryReturnTypeInAnyScope(string theName) 
{
	if (scopeStack.empty( )) return(false);
	bool found = scopeStack.top( ).findEntry(theName);
	if (found) 
		return(scopeStack.top( ).findEntryReturnType(theName));
	else 
	{ // check in "next higher" scope
		SYMBOL_TABLE symbolTable = scopeStack.top( );
		scopeStack.pop( );
		found = findEntryInAnyScope(theName);
		scopeStack.push(symbolTable); // restore the stack
		return(scopeStack.top( ).findEntryReturnType(theName));
	}
}

bool isIntCompatible( int type)
{
	return (type == INT || type == INT_or_STR);
}

bool isStrCompatible( int type)
{
	return (type == STR || type == INT_or_STR);
}

bool isFunctionCompatible(int type)
{
	return type == FUNCTION;
}

int main() 
{
  do{
       yyparse();
    } while (!feof(yyin));
    return 0;
}
