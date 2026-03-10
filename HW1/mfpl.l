/*
Author: Margret Steele
Class: CS256
Date: 8/28/2012
Assignment: 1
Purpose: A simple MFPL lexical analyzer

Running instructions: flex this file, then compile the outputed lex.yy.c file
with g++. Use that outputed file to run. Can be given an input file or command
line input.
*/

%{

/* Defns of constants, variables, function prototypes, and #include’s go here */
#define T_LET      1
#define T_LAMBDA   2
#define T_INPUT    3
#define T_PRINT    4
#define T_IF       5
#define T_LPAREN   6 
#define T_RPAREN   7
#define T_ADD      8
#define T_MULT     9
#define T_DIV      10
#define T_SUB      11
#define T_IDENT    12
#define T_INTCONST 13
#define T_STRCONST 14
#define T_COMMENT  15
#define T_UNKNOWN  16

int numLines = 0;

void printTokenInfo(const char* tokenType, const char* lexeme);

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
             printTokenInfo("LET", yytext);
             return T_LET;
           }
{LAMBDA}   {
             printTokenInfo("LAMBDA", yytext);
             return T_LAMBDA;
           }
{INPUT}    {
             printTokenInfo("INPUT", yytext);
             return T_INPUT;
           }
{PRINT}    {
             printTokenInfo("PRINT", yytext);
             return T_PRINT;
           }
{IF}       {
             printTokenInfo("IF", yytext);
             return T_IF;
           }
{IDENT}    {
             printTokenInfo("IDENT", yytext);
             return T_IDENT;
           }
{INTCONST} {
           printTokenInfo("INTCONST", yytext);
           return T_INTCONST;
           }
{STRCONST} {
             printTokenInfo("STRCONST", yytext);
             return T_STRCONST;
           }
{LPAREN}   {  
             printTokenInfo("LPAREN", yytext);
             return T_LPAREN;
           }
{RPAREN}   {
             printTokenInfo("RPAREN", yytext);
             return T_RPAREN;
           }
{ADD}      {
             printTokenInfo("ADD", yytext);
             return T_ADD;
           }
{MULT}     {
             printTokenInfo("MULT", yytext);
             return T_MULT;
           }
{DIV}      {
             printTokenInfo("DIV", yytext);
             return T_DIV;
           }
{SUB}      {
             printTokenInfo("SUB", yytext);
             return T_SUB;
           }
{COMMENT}  { }
{NEWLINE}  {
              numLines++;
           }
{WSPACE}   { }
.          {
              printTokenInfo("UNKNOWN", yytext);
              return T_UNKNOWN;
           }

%%

// User-written code goes here
void printTokenInfo(const char* tokenType, const char* lexeme) 
{
    printf("TOKEN: %s\t LEXEME: %s\n", tokenType, lexeme);
}

// You should specify a yywrap function.
// Having it return 1 means only 1 input file will be scanned.
int yywrap() { return 1; }

int main( ) 
{
    while ( yylex() ) ; // Keep processing tokens until 0 returned
    printf("Processed %d lines\n", numLines);
    return 0;
}