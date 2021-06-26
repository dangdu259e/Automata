/*** C library use and declare variable ***/
%{
#include "bison.tab.h"
void yyerror (char *s);
int yylex();
%}

/*** the actual token (flex) or grammar (bison definition) ***/
%%
"print"           {return print;}
"exit"            {return exit_command;}
[a-zA-Z]          {yylval.id = yytext[0]; return identifier;}
[0-9]+            {yylval.num = atoi(yytext); return number;}
[ \t]             ;
[-+*/=]           {return  yytext[0];}
[ \n]             {return  yytext[0];}
.                 {ECHO; yyerror ("unexpected character");}
%%

/*** Xử lý kết thúc tệp ***/ 
int yywrap (void) {return 1;}