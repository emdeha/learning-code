#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <string.h>

static char buffer[2048];

char* readline(char *prompt) {
  fputs(prompt, stdout);
  fgets(buffer, 2048, stdin);
  char *cpy = malloc(strlen(buffer) + 1);
  strcpy(cpy, buffer);
  cpy[strlen(cpy) - 1] = '\0';
  return cpy;
}

void add_history(char *unused) {}

#else
#include <editline/readline.h>
#include <editline/history.h>
#endif

#include "mpc.h"


enum { LVAL_NUM, LVAL_ERR };

enum { LERR_DIV_ZERO, LERR_BAD_OP, LERR_BAD_NUM };

typedef struct {
  int type;
  union {
    long num;
    int err;
  };
} lval;

lval lval_num(long x) {
  lval v;
  v.type = LVAL_NUM;
  v.num = x;
  return v;
}

lval lval_err(int err) {
  lval v;
  v.type = LVAL_ERR;
  v.err = err;
  return v;
}

void lval_print(lval v) {
  if (v.type == LVAL_NUM) {
    printf("%li", v.num);
    return;
  }

  if (v.type == LVAL_ERR) {
    switch(v.err) {
      case LERR_DIV_ZERO:
        printf("Error: Division by zero!");
        break;
      case LERR_BAD_OP:
        printf("Error: Invalid operator!");
        break;
      case LERR_BAD_NUM:
        printf("Error: Invalid number!");
        break;
    }
  }
}

void lval_println(lval v) {
  lval_print(v);
  putchar('\n');
}


long power(long x, long y) {
  long i = 1;
  for (; i < y; i++) {
    x *= x;
  }
  return x;
}

long max(long a, long b) {
  return a < b ? b : a;
}

long min(long a, long b) {
  return a > b ? b : a;
}

lval eval_op(lval x, char *op, lval y) {
  if (x.type == LVAL_ERR) { return x; }
  if (y.type == LVAL_ERR) { return y; }

  if (strcmp(op, "+") == 0) { return lval_num(x.num + y.num); }
  if (strcmp(op, "-") == 0) { return lval_num(x.num - y.num); }
  if (strcmp(op, "*") == 0) { return lval_num(x.num * y.num); }
  if (strcmp(op, "/") == 0) {
    if (y.num == 0) {
      return lval_err(LERR_DIV_ZERO);
    }
    return lval_num(x.num / y.num);
  }
  if (strcmp(op, "%") == 0) {
    if (y.num == 0) {
      return lval_err(LERR_DIV_ZERO);
    }
    return lval_num(x.num % y.num);
  }
  if (strcmp(op, "^") == 0) { return lval_num(power(x.num, y.num)); }
  if (strcmp(op, "max") == 0) { return lval_num(max(x.num, y.num)); }
  if (strcmp(op, "min") == 0) { return lval_num(min(x.num, y.num)); }

  return lval_err(LERR_BAD_OP);
}

lval eval(mpc_ast_t *t) {
  if (strstr(t->tag, "number")) {
    errno = 0;
    long x = strtol(t->contents, NULL, 10);
    return errno != ERANGE ? lval_num(x) : lval_err(LERR_BAD_NUM);
  }

  char *op = t->children[1]->contents;

  lval x = eval(t->children[2]);
  if (strcmp(op, "-") == 0 && !strstr(t->children[3]->tag, "expr")) {
    return x.type == LVAL_ERR ? x : lval_num(-x.num);
  }

  int i = 3;
  while (strstr(t->children[i]->tag, "expr")) {
    x = eval_op(x, op, eval(t->children[i]));
    i++;
  }

  return x;
}

int main(int argc, char **argv) {
  mpc_parser_t *Number = mpc_new("number");
  mpc_parser_t *Operator = mpc_new("operator");
  mpc_parser_t *OpSymbol = mpc_new("op_symbol");
  mpc_parser_t *OpText = mpc_new("op_text");
  mpc_parser_t *Expr = mpc_new("expr");
  mpc_parser_t *Lispy = mpc_new("lispy");

  mpca_lang(MPCA_LANG_DEFAULT,
    "                                                            \
      number: /-?[0-9]+([.][0-9]+)?/ ;                           \
      op_symbol: '+' | '-' | '/' | '*' | '%' | '^' ;             \
      op_text: \"add\" | \"sub\" | \"mul\" | \"div\" | \"mod\" | \
        \"min\" | \"max\" ;                                      \
      operator: <op_symbol> | <op_text> ;                        \
      expr: <number> | '(' <operator> <expr>+ ')' ;              \
      lispy: /^/ <operator> <expr>+ /$/ ;                        \
    ",
    Number, Operator, OpSymbol, OpText, Expr, Lispy);

  puts("HaskLisp version 0.0.0");
  puts("Press Ctrl+c to Exit\n");

  while (1) {
    char *input = readline("\\> ");
    add_history(input);
    mpc_result_t r;
    if (mpc_parse("<stdin>", input, Lispy, &r)) {
      lval result = eval(r.output);
      lval_println(result);
      mpc_ast_delete(r.output);
    } else {
      mpc_err_print(r.error);
      mpc_err_delete(r.error);
    }
    free(input);
  }

  mpc_cleanup(6, Number, Operator, OpSymbol, OpText, Expr, Lispy);
  return 0;
}
