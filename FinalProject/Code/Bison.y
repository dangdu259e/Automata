//	C declarations: Các khai báo trong C
%{
void yyerror (char *s); // The Error Reporting Function
int yylex(); // the lexical analyzer function ==> nhận mã thông báo từ luồng đầu vào và trả chúng về phân tích cú pháp
// Bison không tự trả về nên cần viết thêm yyparse để có thể gọi yylex() ==> gọi là máy quét từ 

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

%}

//	Bison definitions: Các khai báo cho bảng trong bison 
//	maybe: %token, %union, %type, %left, %right, %nonassoc, .
//	%union: khai báo đối tượng như class
%union {int num; char id;}

//	%start: The Start-Symbol
%start line
//	%token: Declare token
%token print
%token exit_command
// 	%token: khai kiểu từng loại token
%token <num> number
%token <id> identifier
// %type: Nonterminal Symbols: ký hiệu danh nghĩa
// Khai báo kiểu giá trị mỗi ký hiệu danh nghĩa mà union dùng
%type <num> line exp term 
%type <id> assignment


//	Grammar Rules
%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment '\n'			{;} 							// Không làm bất cứ điều gì khi nhận được dấu ;
		| exit_command '\n'			{exit(EXIT_SUCCESS);} 			// Exit khỏi ctrình
		| print exp '\n'			{printf("Printing %d\n", $2);} 	// in biểu thức
		| line assignment '\n'		{;} 							// dòng
		| line print exp '\n'		{printf("Printing %d\n", $3);} 	// in ra dòng biểu thức
		| line exit_command '\n'	{exit(EXIT_SUCCESS);} 			// dòng kết thúc
        ;

// read variable assignment line
assignment 	: identifier '=' exp  { updateSymbolVal($1,$3); }
			;

// read expression line 
exp    	: term                  {$$ = $1;}
       	| exp '+' term          {$$ = $1 + $3;}
       	| exp '-' term          {$$ = $1 - $3;}
		| exp '*' term			{$$ = $1 * $3;}
		| exp '/' term			{$$ = $1 / $3;}
       	;

term   	: number                {$$ = $1;}
		| identifier			{$$ = symbolVal($1);} 
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
	// scan fileName
	// char fileName[];
	// scanf ("%s", fileName);

	// open a file handle to a particular file:
	char fileName[] = "input.txt";
	FILE *myfile = fopen(fileName, "r");
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