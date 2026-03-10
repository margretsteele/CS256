/*
Author: Margret Steele
Class: CS256
Date: 9/9/2012
Assignment: 2
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