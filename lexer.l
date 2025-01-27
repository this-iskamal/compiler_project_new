
%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
#include "symtab.h"

int line_no = 1;
#define DEBUG_LEXER 1
%}

%%

"yadi"          { 
    #ifdef DEBUG_LEXER
    fprintf(stderr, "LEX: Found IF\n"); 
    #endif
    return IF; 
}
"natra"         { 
    #ifdef DEBUG_LEXER
    fprintf(stderr, "LEX: Found ELSE\n"); 
    #endif
    return ELSE; 
}
"jaba_samma"    { 
    #ifdef DEBUG_LEXER
    fprintf(stderr, "LEX: Found WHILE\n"); 
    #endif
    return WHILE; 
}
"dekha"         { 
    #ifdef DEBUG_LEXER
    fprintf(stderr, "LEX: Found PRINT\n"); 
    #endif
    return PRINT; 
}

[0-9]+          { 
    #ifdef DEBUG_LEXER
    fprintf(stderr, "LEX: Found NUMBER: %s\n", yytext); 
    #endif
    yylval.num = atoi(yytext); 
    return NUMBER; 
}
[a-zA-Z_][a-zA-Z0-9_]*  { 
    #ifdef DEBUG_LEXER
    fprintf(stderr, "LEX: Found IDENTIFIER: %s\n", yytext); 
    #endif
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
"="             { return ASSIGN; }
"=="            { return EQ; }
"!="            { return NEQ; }
"<"             { return LT; }
">"             { return GT; }
"<="            { return LTE; }
">="            { return GTE; }

"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
";"             { return SEMICOLON; }

[ \t]           ; /* Skip whitespace */
\n              { line_no++; }
.               { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}