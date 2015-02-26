%{
#include <stdio.h>
#include <ctype.h>
%}

%token END_TOKEN NUM AM PM
%start time

%%

time: time_spec END_TOKEN 
	{
		if ($1 < 0 || $1 > 24) yyerror("Incorrect");
		printf("Time: %i hours", $1);
		getchar();
		exit(0);
	}
;

time_spec:
		hour 
		{ 
			$$ = $1; 
		}
		| 
		hour suffix
		{ 
			$$ = $1; 
		}
		| 
		hour ':' minute
		{
			$$ = $1;
 		}
		|
		hour ':' minute suffix
		{
			$$ = $1;	
		}
;

hour: 
		NUM 	{ $$ = $1; }
		|
		NUM NUM { $$ = $1*10 + $2; }
;

minute:
		NUM NUM { $$ = $1*10 + $2; }
;

suffix: 
		AM { $$ = "am"; }
		|
		PM { $$ = "pm"; }
;

		
%%

const char *cp;

int yylex()
{
	char ch = *cp; 

	if(!ch)
		return END_TOKEN;
	
	cp++;
	if (isdigit(ch))
	{
		yylval = ch - '0';
		return NUM;
	}

	if (((ch == 'a') || (ch == 'p')) && (*cp == 'm'))
	{
		cp++;
		return (ch == 'a') ? AM : PM;
	}

	return ch;
}

int yyerror(char *s)
{
	printf("Error: %s\n", s);
	getchar();
	return 0;
}

int main(int argc, char **argv)
{
	cp = "12:10pm";
	yyparse();
}

