%{
// library C use in code 
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

// 26 symbol a-z
// 26 symbol A-Z
// ==> sum symbol [a-zA-Z] = 26*2 = 52
int symbols[52]; // symbol input (type = array C)
int symbolVal(char symbol);  // symbol value 
void updateSymbolVal(char symbol, int val); // update value of symbol
extern FILE *yyin;	// repair input to file 

void yyerror (char *s); // The Error Reporting Function
int yylex(); // the lexical analyzer function ==> nhận mã thông báo từ luồng đầu vào và trả chúng về phân tích cú pháp
// Bison không tự trả về nên cần viết thêm yyparse để có thể gọi yylex() ==> gọi là máy quét từ 

%}

%union {
    int value;
    char symbol;
    char* string;
}

%start line
// a = 3 => SYM = a, NUM = 3
%token <symbol> SYM //symbol
%token <value> NUM //number =  value symbol

// Phép toán
%token EQN //equal "="
%token ADD //addition "+"
%token SUB //subtraction "-"
%token MUL //multiplication "*"
%token DIV //division "/"
%token MOD //division "/"

%token END // end line '/n'

%type <value> exp term
%type <symbol> ADD SUB MUL DIV MOD
%type <string> END assignment



// Grammar rules
%%
line    		: assignment END line	{;}
				| {;}
        		;

assignment     	: SYM EQN NUM		{updateSymbolVal($1,$3);}
				| exp				{printf("%d \n", $$);}
        		;

exp     		: term 		   		{$$ = $1; }
				| exp ADD term 		{$$ = $1 + $3; }
        		| exp SUB term 		{$$ = $1 - $3; }
				| exp MUL term		{$$ = $1 * $3; }
				| exp DIV term 		{$$ = $1 / $3; }
				| exp MOD term		{$$ = $1 % $3; }
        		;
     
term		    : NUM   {$$ = $1; }
				| SYM	{$$ = symbolVal($1); }
				;

%%


//	Additional C Code
int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	// VD a = 10
	// bucket = vị trí mà đặt từ đó, token = a ==> idx = bucket = a - 'a' + 26
	int bucket = computeSymbolIndex(symbol);
	// val = value của từ đó 
	// val = 10
	symbols[bucket] = val;
}


int main (void) {
	// // input fileName by  
	// scan fileName
	// char fileName[];
	// scanf ("%s", fileName);

	// open a file handle to a particular file:
	char fileName[] = "input.txt";
	FILE *myfile = fopen(fileName, "r");
	printf("%s", myfile);
	// make sure it's valid:
	if (!myfile) {
		printf("I can't open file %d \n", fileName);
		return -1;
	}

	// Set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// create symbols
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

// catch error
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 




