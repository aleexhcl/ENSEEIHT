#include "aux.h"

int tot_visited, to_be_visited;
unsigned long res;
unsigned long check_res;

void generate_tree(int nnodes, struct node ***leaves, int *nleaves){

  FILE   *fp;
  char   *mode = "w";

  int id = nnodes;


  *leaves       = (struct node **)malloc(nnodes*sizeof(struct node *));
  *nleaves      = 0;
  tot_visited   = 0;
  res           = 0;
  check_res     = 0;
  to_be_visited = nnodes;
  
  if(nnodes<=100){
    fp = fopen("td_tree.dot", mode);
    fprintf(fp, "graph G {\nnode [color=black,\nfillcolor=white,\nshape=circle,\nstyle=filled\n];\n");
  } else {
    fp = NULL;
  }
  
  generate_node(NULL, nnodes, &id, *leaves, nleaves, fp);
  
  if(nnodes<=100){
    fprintf(fp, "}\n");
    fclose(fp);
  }
  
}



void generate_node(struct node *parent, int nnodes, int *id, struct node **leaves, int *nleaves, FILE *fp){

  int i;
  struct node *curr;

  curr = (struct node*) malloc(sizeof(struct node));

  curr->parent  = parent;
  curr->id      = *id;
  *id           = *id - 1;
  nnodes        = nnodes -1;
  unsigned nc   = (rand()%NCHILDREN) +2;
  nc            = MIN(nc,nnodes);
  curr->data    = rand()%100 +1;
  res          += curr->data;
  
  if(nc==0) {
    leaves[*nleaves] = curr;
    *nleaves += 1;
  }
  
  if(curr->parent==NULL){
    /* printf("Node %5d -- nc %d parent N\n",curr->id, nc); */
  } else {
    /* printf("Node %5d -- nc %d parent %d\n",curr->id, nc, curr->parent->id); */
    if(fp!=NULL)
      fprintf(fp, "%d -- %d \n", curr->parent->id, curr->id);
  }
  
  
  for(i=0; i<nc; i++) {
    unsigned nn=nnodes/nc;
    if(i==nc-1)
      nn = nn + nnodes%nc;
    generate_node(curr, nn, id, leaves, nleaves, fp);
  }
  

}
  


long usecs (){
  struct timeval t;

  gettimeofday(&t,NULL);
  return t.tv_sec*1000000+t.tv_usec;
}


void mysleep(double sec){

  long s, e;
  s=0; e=0;
  s = usecs();
  while(((double) e-s)/1000000 < sec)
    {
      e = usecs();
    }
  return;
}


void process_node(struct node *node){
  /* if(node->parent!=NULL){ */
    /* printf("%d -- Visiting node %d %d\n",omp_get_thread_num(), node->id, node->parent->visited); */
  /* } else { */
    /* printf("%d -- Visiting node %d\n",omp_get_thread_num(), node->id); */
  /* } */
#pragma omp atomic update
  tot_visited++;
#pragma omp atomic update
  check_res += node->data;
  mysleep(0.0001);
  return ;
}


void check_result(){
  if((tot_visited==to_be_visited) && (check_res==res)){
    printf("The result is CORRECT\n");
  } else {
    printf("The result is WRONG!!!!  %d  %lu  %lu\n",tot_visited,res,check_res);
  }
}
