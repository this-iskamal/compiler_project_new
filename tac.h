#ifndef TAC_H
#define TAC_H

struct node {
    char* type;
    char* value;
    struct node* left;
    struct node* right;
};

struct node* create_number_node(int value);
struct node* create_id_node(char* name);
struct node* create_op_node(char* op, struct node* left, struct node* right);
struct node* create_condition(char* op, struct node* left, struct node* right);

void emit_assignment(char* id, struct node* expr);
void emit_if(struct node* condition, int label);
void emit_if_else(struct node* condition, int label1, int label2);
void emit_while(int start_label, struct node* condition, int end_label);
void emit_print(struct node* expr);
void emit_label(int label);
int new_label(void);
char* new_temp(void);

#endif