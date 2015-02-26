%{
#define YYSTYPE double
#include <ctype.h>
#include <stdio.h>
#include <math.h>
%}

%token NUM

%%

input: /* empty */ 
	 | input line
;

line: '\n' 
	| exp '\n' { printf("\t%.10g\n", $1); }
;

exp: NUM 		   { $$ = $1; }
    | exp exp '+'  { $$ = $1 + $2; }
	| exp exp '-'  { $$ = $1 - $2; }
;

%%

int yylex(void)
{
	int c;
	
	/* skipt white space */
	while ((c = getchar()) == ' ' || c == '\t')
		;
	
	/* process numbers */
	if (c == '.' || isdigit(c))
	{
		ungetc(c, stdin);
		scanf("%lf", &yylval);
		return NUM;
	}

	/* return EOF */ 
	if (c == EOF)
		return 0;
	
	/* return single chars */
	return c;
}

void yyerror(const char *s)
{
	printf("%s\n", s);
}

int main(void)
{
	yyparse();
}

