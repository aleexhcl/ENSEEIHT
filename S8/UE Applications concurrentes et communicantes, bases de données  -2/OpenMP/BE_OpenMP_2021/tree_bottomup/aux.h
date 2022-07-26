#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <sys/time.h>

#define NCHILDREN 2
#define MIN(a,b) (((a)<(b))?(a):(b))


struct node{
  unsigned       id;
  unsigned long  data;
  struct node    *parent;
};

void generate_node(struct node *parent, int nnodes, int *id, struct node **leaves, int *nleaves, FILE *fp);
void process_node(struct node *node);
long usecs ();
void check_result();
void generate_tree(int nnodes, struct node ***leaves, int *nleaves);

  
