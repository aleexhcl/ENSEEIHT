#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

void sequential_nn(layer *layers, int n, int L);
void parallel_nn_loops(layer *layers, int n, int L);
void parallel_nn_tasks(layer *layers, int n, int L);

int main(int argc, char **argv){
  int   n, m, N, L, i;
  long  t_start, t_end;
  layer *layers_se, *layers_pl, *layers_pt;
  
  // Command line arguments
  if ( argc == 3 ) {
    n = atoi(argv[1]);    /* size of layers */
    L = atoi(argv[2]);    /* number of layers in the network */
  } else {
    printf("Usage:\n\n ./main n L\n\nsuch that n is the size of the layers and L is the number of layers.\n");
    return 1;
  }

  layers_se = (layer*) malloc(sizeof(layer)*L);
  layers_pl = (layer*) malloc(sizeof(layer)*L);
  layers_pt = (layer*) malloc(sizeof(layer)*L);

  init(layers_se, n, L);
  copy_nn(layers_se, layers_pl, n, L);
  copy_nn(layers_se, layers_pt, n, L);
  

  t_start = usecs();
  sequential_nn(layers_se, n, L);
  t_end = usecs();
  printf("Sequential     time    : %8.2f msec.\n",((double)t_end-t_start)/1000.0);


  t_start = usecs();
  parallel_nn_loops(layers_pl, n, L);
  t_end = usecs();
  printf("Parallel loops time    : %8.2f msec.    ",((double)t_end-t_start)/1000.0);

  check_result(layers_se, layers_pl, n, L);
  

  t_start = usecs();
  parallel_nn_tasks(layers_pt, n, L);
  t_end = usecs();
  printf("Parallel tasks time    : %8.2f msec.    ",((double)t_end-t_start)/1000.0);

  check_result(layers_se, layers_pt, n, L);

  return 0;
  
}


void sequential_nn(layer *layers, int n, int L){
  int i, j, k, l, s;
  
  for(l=0; l<L-1; l++){
    /* printf("layer %2d  m:%2d\n",l,layers[l].m); */
    for(s=0; s<layers[l].m; s++){
      i = layers[l].syn[s].i;
      j = layers[l].syn[s].j;
      /* printf("layer %2d  i:%2d  j:%2d\n",l,i,j); */
      layers[l+1].neu[j].nv += update(layers[l].neu[i].nv, layers[l].syn[s].sv);
    }
  }
}


void parallel_nn_loops(layer *layers, int n, int L){
  int i, j, k, l, s;

#pragma omp parallel private(l,s,i,j)
{
  for(l=0; l<L-1; l++){
    /* printf("layer %2d  m:%2d\n",l,layers[l].m); */
#pragma omp for 
    for(s=0; s<layers[l].m; s++){
      i = layers[l].syn[s].i;
      j = layers[l].syn[s].j;
      /* printf("layer %2d  i:%2d  j:%2d\n",l,i,j); */
      layers[l+1].neu[j].nv += update(layers[l].neu[i].nv, layers[l].syn[s].sv);
    }
  }
}
}



void parallel_nn_tasks(layer *layers, int n, int L){
  int i, j, k, l, s;

#pragma omp parallel 
{
#pragma omp master
{
  for(l=0; l<L-1; l++){
    /* printf("layer %2d  m:%2d\n",l,layers[l].m); */
    for(s=0; s<layers[l].m; s++){
      i = layers[l].syn[s].i;
      j = layers[l].syn[s].j;
      /* printf("layer %2d  i:%2d  j:%2d\n",l,i,j); */
#pragma omp task depend(inout : layers[l+1].neu[j].nv) depend(in : layers[l].neu[i].nv, layers[l].syn[s].sv) firstprivate(i,j,l,s)
      {
      layers[l+1].neu[j].nv += update(layers[l].neu[i].nv, layers[l].syn[s].sv);
      }
    }
#pragma omp taskwait 
  }
}
}
}

/* 
résultats :

POUR 4 THREADS :
./main 10 10
Sequential     time    :   673.86 msec.
Parallel loops time    :   215.82 msec.    Result is correct :-)
Parallel tasks time    :   217.03 msec.    Result is correct :-)

les versions avec le for et les taches sont en effet plus efficaces que la version
séquentielle. 

./main 20 15
Sequential     time    :  4195.34 msec.
Parallel loops time    :  1224.63 msec.    Result is correct :-)
Parallel tasks time    :  1161.16 msec.    Result is correct :-)

La version parallèle utilisant les taches devient plus rapide que la version avec for 
lorsque l'on augement le réseau de neuronne. 

POUR 2 THREADS :
./main 10 10
Sequential     time    :   673.88 msec.
Parallel loops time    :   386.73 msec.    Result is correct :-)
Parallel tasks time    :   357.13 msec.    Result is correct :-)

les versions avec le for et les taches restent plus efficaces, 
le nombre de thread étant plus petit, les versions sont plus lentes que la précédente. 

POUR 1 THREAD :
./main 10 10
Sequential     time    :   673.86 msec.
Parallel loops time    :   673.87 msec.    Result is correct :-)
Parallel tasks time    :   673.88 msec.    Result is correct :-)

les trois versions sont les mêmes avec un thread. 

*/

