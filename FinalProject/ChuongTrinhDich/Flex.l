/*** C library use and declare variable ***/
/***http://tailieudientu.lrc.tnu.edu.vn/Upload/Collection/brief/brief_8298_14281_PVT00005.pdf ***/
%{
#include "bison.tab.h"
void yyerror (char *s);
int yylex();
%}

/*** the actual token (flex) or grammar (bison definition) ***/
%%
[a-zA-Z]    {yylval.symbol = yytext[0]; return SYM;}
[0-9]+      {yylval.value = atoi(yytext); return NUM;}
[ \t]       ;
[=]         {yylval.symbol = yytext[0]; return EQN;}
[+]         {yylval.symbol = yytext[0]; return ADD;}
[-]         {yylval.symbol = yytext[0]; return SUB;}
[*]         {yylval.symbol = yytext[0]; return MUL;}
[/]         {yylval.symbol = yytext[0]; return DIV;}
[%]         {yylval.symbol = yytext[0]; return MOD;}
[\n]        {yylval.symbol = yytext[0]; return END;}
.           {ECHO; yyerror ("unexpected character");}
%%

/*** Xử lý kết thúc tệp ***/ 
int yywrap (void) {return 1;}