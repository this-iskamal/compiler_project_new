// tac.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"

static int temp_count = 0;
static int label_count = 0;

struct node* create_number_node(int value) {
    struct node* n = malloc(sizeof(struct node));
    if (!n) {
        fprintf(stderr, "ERROR: Memory allocation failed\n");
        exit(1);
    }
    n->type = strdup("number");
    char* val = malloc(20);
    sprintf(val, "%d", value);
    n->value = val;
    n->left = n->right = NULL;
    return n;
}

struct node* create_id_node(char* name) {
    struct node* n = malloc(sizeof(struct node));
    if (!n) {
        fprintf(stderr, "ERROR: Memory allocation failed\n");
        exit(1);
    }
    n->type = strdup("id");
    n->value = strdup(name);
    n->left = n->right = NULL;
    return n;
}

struct node* create_op_node(char* op, struct node* left, struct node* right) {
    struct node* n = malloc(sizeof(struct node));
    if (!n) {
        fprintf(stderr, "ERROR: Memory allocation failed\n");
        exit(1);
    }
    n->type = strdup("op");
    n->value = strdup(op);
    n->left = left;
    n->right = right;
    return n;
}

struct node* create_condition(char* op, struct node* left, struct node* right) {
    struct node* n = malloc(sizeof(struct node));
    if (!n) {
        fprintf(stderr, "ERROR: Memory allocation failed\n");
        exit(1);
    }
    n->type = strdup("condition");
    n->value = strdup(op);
    n->left = left;
    n->right = right;
    return n;
}

void emit_assignment(char* id, struct node* expr) {
    if (!id || !expr) {
        fprintf(stderr, "ERROR: NULL id or expression in assignment\n");
        return;
    }
    
    if (strcmp(expr->type, "number") == 0) {
        printf("%s := %s;\n", id, expr->value);
    } else if (strcmp(expr->type, "id") == 0) {
        printf("%s := %s;\n", id, expr->value);
    } else if (strcmp(expr->type, "op") == 0) {
        char temp[20];
        sprintf(temp, "t%d", temp_count++);
        printf("%s := %s %s %s;\n", temp, 
               expr->left->value, expr->value, expr->right->value);
        printf("%s := %s;\n", id, temp);
    }
    fflush(stdout);
}

void emit_print(struct node* expr) {
    if (!expr) {
        fprintf(stderr, "ERROR: NULL expression in print\n");
        return;
    }
    
    if (strcmp(expr->type, "number") == 0 || strcmp(expr->type, "id") == 0) {
        printf("PRINT %s;\n", expr->value);
    } else {
        char temp[20];
        sprintf(temp, "t%d", temp_count++);
        printf("%s := %s %s %s;\n", temp,
               expr->left->value, expr->value, expr->right->value);
        printf("PRINT %s;\n", temp);
    }
    fflush(stdout);
}

void emit_if(struct node* condition, int label) {
    if (!condition) {
        fprintf(stderr, "ERROR: NULL condition in if statement\n");
        return;
    }
    
    printf("IF %s %s %s GOTO L%d;\n",
           condition->left->value, condition->value, condition->right->value, label);
    fflush(stdout);
}

void emit_if_else(struct node* condition, int label1, int label2) {
    if (!condition) {
        fprintf(stderr, "ERROR: NULL condition in if-else statement\n");
        return;
    }
    
    printf("IF %s %s %s GOTO L%d;\n",
           condition->left->value, condition->value, condition->right->value, label1);
    printf("GOTO L%d;\n", label2);
    fflush(stdout);
}

void emit_while(int start_label, struct node* condition, int end_label) {
    if (!condition) {
        fprintf(stderr, "ERROR: NULL condition in while loop\n");
        return;
    }
    
    printf("L%d:\n", start_label);
    printf("IF %s %s %s GOTO L%d;\n",
           condition->left->value, condition->value, condition->right->value, end_label);
    printf("GOTO L%d;\n", start_label);
    printf("L%d:\n", end_label);
    fflush(stdout);
}

void emit_label(int label) {
    printf("L%d:\n", label);
    fflush(stdout);
}

char* new_temp() {
    char* temp = malloc(20);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

int new_label() {
    return label_count++;
}