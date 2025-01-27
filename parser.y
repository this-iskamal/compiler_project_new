// parser.y
%{
#include <stdio.h>
#include <stdlib.h>
#include "symtab.h"
#include "tac.h"

extern int yylex();
extern int line_no;
void yyerror(const char *s);

int temp_var_count = 0;
int label_count = 0;
%}

%error-verbose

%union {
    int num;
    char* str;
    struct node* ast;
}

%token <num> NUMBER
%token <str> IDENTIFIER
%token PLUS MINUS MULTIPLY DIVIDE
%token ASSIGN EQ NEQ LT GT LTE GTE
%token IF ELSE WHILE PRINT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token AND OR

%type <ast> expr stmt stmt_list condition

%%

program: 
    stmt_list {
        fprintf(stderr, "DEBUG: Completed parsing program\n");
        fflush(stderr);
    }
    ;

stmt_list: 
    stmt {
        fprintf(stderr, "DEBUG: Added statement to list\n");
        fflush(stderr);
    }
    | stmt_list stmt {
        fprintf(stderr, "DEBUG: Added another statement to list\n");
        fflush(stderr);
    }
    ;

stmt: 
    IDENTIFIER ASSIGN expr SEMICOLON {
        fprintf(stderr, "DEBUG: Processing assignment statement for %s\n", $1);
        emit_assignment($1, $3);
        fflush(stdout);
    }
    | IF LPAREN condition RPAREN LBRACE stmt_list RBRACE {
        fprintf(stderr, "DEBUG: Processing if statement\n");
        int label = new_label();
        emit_if($3, label);
        emit_label(label);
        fflush(stdout);
    }
    | IF LPAREN condition RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE {
        fprintf(stderr, "DEBUG: Processing if-else statement\n");
        int label1 = new_label();
        int label2 = new_label();
        emit_if_else($3, label1, label2);
        emit_label(label1);
        emit_label(label2);
        fflush(stdout);
    }
    | WHILE LPAREN condition RPAREN LBRACE stmt_list RBRACE {
        fprintf(stderr, "DEBUG: Processing while statement\n");
        int start_label = new_label();
        int end_label = new_label();
        emit_while(start_label, $3, end_label);
        fflush(stdout);
    }
    | PRINT expr SEMICOLON {
        fprintf(stderr, "DEBUG: Processing print statement\n");
        emit_print($2);
        fflush(stdout);
    }
    | error SEMICOLON {
        yyerrok;
    }
    ;

condition: 
    expr EQ expr { 
        $$ = create_condition("==", $1, $3); 
    }
    | expr NEQ expr { 
        $$ = create_condition("!=", $1, $3); 
    }
    | expr LT expr { 
        $$ = create_condition("<", $1, $3); 
    }
    | expr GT expr { 
        $$ = create_condition(">", $1, $3); 
    }
    | expr LTE expr { 
        $$ = create_condition("<=", $1, $3); 
    }
    | expr GTE expr { 
        $$ = create_condition(">=", $1, $3); 
    }
    ;

expr: 
    NUMBER { 
        $$ = create_number_node($1); 
    }
    | IDENTIFIER { 
        $$ = create_id_node($1); 
    }
    | expr PLUS expr { 
        $$ = create_op_node("+", $1, $3); 
    }
    | expr MINUS expr { 
        $$ = create_op_node("-", $1, $3); 
    }
    | expr MULTIPLY expr { 
        $$ = create_op_node("*", $1, $3); 
    }
    | expr DIVIDE expr { 
        $$ = create_op_node("/", $1, $3); 
    }
    | LPAREN expr RPAREN { 
        $$ = $2; 
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", line_no, s);
    fflush(stderr);
}

int main() {
    fprintf(stderr, "DEBUG: Starting compilation\n");
    fflush(stderr);
    
    init_symtab();
    
    int result = yyparse();
    
    fprintf(stderr, "DEBUG: Compilation finished with result %d\n", result);
    fflush(stderr);
    
    return result;
}