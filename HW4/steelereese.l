/*
Author: Margret Steele and Thomas Reese
Class: CS256
Date: 10/14/2012
Assignment: 4
Purpose: A simple MFPL lexical analyzer

Running instructions: flex this file, then compile the outputed lex.yy.c file
with bison. G++ the bison'd file and then use that outputed file to run. Can 
be given an input file or command line input.
*/

%{
%}

/* Defns of regular expressions go here */
WSPACE [ \t\r]+
NEWLINE \n

DIGIT [0-9]
LETTER [a-zA-Z]

IDENT ({LETTER}|_)({LETTER}|{DIGIT}|_)*
INTCONST (\+|\-)*{DIGIT}+
STRCONST \".*\"

LET    "let"
IF     "if"
PRINT  "print"
INPUT  "input"
LAMBDA "lambda"

LPAREN "("
RPAREN ")"
ADD    "+"
MULT   "*"
DIV    "/"
SUB    "-"
COMMENT (%)(.)*$

%%

{LET}      {
				printf("TOKEN: LET       LEXEME: %s\n", yytext);
				beginScope();
				return T_LET;
           }
{LAMBDA}   {
				printf("TOKEN: LAMBDA    LEXEME: %s\n", yytext);
				beginScope();
				return T_LAMBDA;
           }
{INPUT}    {
				printf("TOKEN: INPUT     LEXEME: %s\n", yytext);
				return T_INPUT;
           }
{PRINT}    {
				printf("TOKEN: PRINT     LEXEME: %s\n", yytext);
				return T_PRINT;
           }
{IF}       {
				printf("TOKEN: IF        LEXEME: %s\n", yytext);
				return T_IF;
           }
{IDENT}    {
				yylval.text = strdup(yytext);
				printf("TOKEN: IDENT     LEXEME: %s\n", yytext);
				return T_IDENT;
           }
{INTCONST} {
				printf("TOKEN: INTCONST  LEXEME: %s\n", yytext);
				return T_INTCONST;
           }
{STRCONST} {
				printf("TOKEN: STRCONST  LEXEME: %s\n", yytext);
				return T_STRCONST;
           }
{LPAREN}   {  
				printf("TOKEN: LPAREN    LEXEME: %s\n", yytext);
				return T_LPAREN;
           }
{RPAREN}   {
				printf("TOKEN: RPAREN    LEXEME: %s\n",yytext);
				return T_RPAREN;
           }
{ADD}      {
				printf("TOKEN: ADD       LEXEME: %s\n", yytext);
				return T_ADD;
           }
{MULT}     {
				printf("TOKEN: MULT      LEXEME: %s\n", yytext);
				return T_MULT;
           }
{DIV}      {
				printf("TOKEN: DIV       LEXEME: %s\n", yytext);
				return T_DIV;
           }
{SUB}      {
				printf("TOKEN: SUB       LEXEME: %s\n", yytext);
				return T_SUB;
           }
{COMMENT}  { }
{NEWLINE}  {
				numLines++;
           }
{WSPACE}   { }
.          {
				printf("TOKEN: UNKNOWN     LEXEME: %s\n", yytext);
				return T_UNKNOWN;
           }

%%
