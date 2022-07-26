#include "aux.h"


void bottom_up(int nleaves, struct node **leaves, int nnodes);
void bottom_up_par(int nleaves, struct node **leaves, int nnodes);

int main(int argc, char **argv){
  long   t_start, t_end;
  int    nnodes, nleaves;
  struct node **leaves;

  // Command line argument: number of nodes in the tree
  if ( argc == 2 ) {
    nnodes = atoi(argv[1]); 
  } else {
    printf("Usage:\n\n ./main n\n\nwhere n is the number of nodes in the tree.\n");
    return 1;
  }

  printf("\nGenerating a tree with %d nodes\n\n",nnodes);
  generate_tree(nnodes, &leaves, &nleaves);

  t_start = usecs();
  bottom_up(nleaves, leaves, nnodes);
  t_end = usecs();
  
  printf("seq time : %8.2f msec.\n\n",((double)t_end-t_start)/1000.0);

  t_start = usecs();
  bottom_up_par(nleaves, leaves, nnodes);
  t_end = usecs();
  
  printf("par time : %8.2f msec.\n\n",((double)t_end-t_start)/1000.0);

  check_result();
  
}
  

/* You can change the number and type of arguments if needed.     */
/* Just don't forget to update the interface declaration above.   */
void bottom_up(int nleaves, struct node **leaves, int nnodes){

  /* Implement this routine */

  int l,i;
  struct node* ncourant;
  int * nodedejavu;

  nodedejavu = (int*) malloc(sizeof(int)*nnodes);
  for(i=0;i<nnodes;i++){
    nodedejavu[i] = 0;
  }

  for(l=0;l<nleaves;l++){
    ncourant = leaves[l];
    while (ncourant) {
      if (nodedejavu[ncourant->id -1] == 0){
        nodedejavu[ncourant->id -1] = 1;
        process_node(ncourant);
        ncourant = ncourant->parent;
      } else {
        break;
      }
    }
  }
}

void bottom_up_par(int nleaves, struct node **leaves, int nnodes){

  /* Implement this routine */

  int l,i,v;
  int * nodedejavu;
  struct node* ncourant;

  ncourant = (struct node*) malloc(sizeof(struct node));

  nodedejavu = (int*) malloc(sizeof(int)*nnodes);
  for(i=0;i<nnodes;i++){
    nodedejavu[i] = 0;
  }

#pragma omp parallel private(l,ncourant,v)
{
#pragma omp for
  for(l=0;l<nleaves;l++){
    ncourant = leaves[l];
    while (ncourant) {
      #pragma atomic capture
      {
      v = nodedejavu[ncourant->id -1]++;
      }
      if (nodedejavu[ncourant->id -1] < 2){
        #pragma omp atomic capture
        {
        nodedejavu[ncourant->id -1]++;
        }
        process_node(ncourant);
        ncourant = ncourant->parent;
        
      } else {
        break;
      }
    }
  }
}
}


    

