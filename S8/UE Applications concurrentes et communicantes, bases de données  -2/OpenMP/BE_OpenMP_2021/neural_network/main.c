#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

void sequential_nn(layer *Layers, data *D, int n, int m, int L);
void parallel_nn_loops(layer *Layers, data *D, int n, int m, int L);
void parallel_nn_tasks(layer *Layers, data *D, int n, int m, int L);




int main(int argc, char **argv){
  int   n, m, N, L;
  long  t_start, t_end;
  layer *Layers;
  data  *Datas_s, *Datas_pl, *Datas_pt;
  
  // Command line arguments
  if ( argc == 4 ) {
    n = atoi(argv[1]);    /* size of layer matrix n */
    m = atoi(argv[2]);    /* size of batch */
    L = atoi(argv[3]);    /* number of layers in the network */
  } else {
    printf("Usage:\n\n ./main n m L\n\nsuch that nxm is the size of the layers and L is the number of layers and m is the batch size.\n");
    return 1;
  }

  N = (n/m);
  
  
  init_data(&Layers, &Datas_s, &Datas_pl, &Datas_pt, N, m, L);

  
  /* Sequential version */
  t_start = usecs();
  sequential_nn(Layers, Datas_s, N, m, L);
  t_end = usecs();
  printf("Sequential     time    : %8.2f msec.\n",((double)t_end-t_start)/1000.0);



  /* Parallel with loops */
  t_start = usecs();
  parallel_nn_loops(Layers, Datas_pl, N, m, L);
  t_end = usecs();
  printf("Parallel loops time    : %8.2f msec.    ",((double)t_end-t_start)/1000.0);
  /* Comprare the two resulting outputs */
  compare_output(Datas_s[L].X, Datas_pl[L].X, N, m);

  /* Parallel with tasks */
  t_start = usecs();
  parallel_nn_tasks(Layers, Datas_pt, N, m, L);
  t_end = usecs();
  printf("Parallel tasks time    : %8.2f msec.    ",((double)t_end-t_start)/1000.0);
  /* Comprare the two resulting outputs */
  compare_output(Datas_s[L].X, Datas_pt[L].X, N, m);


  return 0;
  
}


void sequential_nn(layer *Layers, data *Datas, int N, int m, int L){
  int i, j, k, l;

  for(l=0; l<L; l++){
    for(i=0; i<N; i++)
      for(j=0; j<N; j++){
        block_mult(Layers[l].W[i][j], Datas[l].X[j], Datas[l+1].X[i], m);
      }
    
    for(i=0; i<N; i++)
      block_bias_act(Layers[l].b[i], Datas[l+1].X[i], m);

  }
}


void parallel_nn_loops(layer *Layers, data *Datas, int N, int m, int L){
  int i, j, l;

#pragma omp parallel private(l,i)
  for(l=0; l<L; l++){
    for(i=0; i<N; i++)
#pragma omp for
      for(j=0; j<N; j++){
        block_mult(Layers[l].W[i][j], Datas[l].X[j], Datas[l+1].X[i], m);
      }
     
    for(i=0; i<N; i++)
      block_bias_act(Layers[l].b[i], Datas[l+1].X[i], m);
    
  }
}



void parallel_nn_tasks(layer *Layers, data *Datas, int N, int m, int L){
  int i, j, l;

#pragma omp parallel num_threads(4)
{
#pragma omp single
{
  for(l=0; l<L; l++){
    for(i=0; i<N; i++)
      for(j=0; j<N; j++){
#pragma omp task depend(inout: Datas[l].X[j], Datas[l+1].X[i]) firstprivate(l,i,j)
{
        block_mult(Layers[l].W[i][j], Datas[l].X[j], Datas[l+1].X[i], m);
}
      }
    
    for(i=0; i<N; i++)
#pragma omp task depend(inout: Datas[l+1].X[i]) firstprivate(l,i)
{
      block_bias_act(Layers[l].b[i], Datas[l+1].X[i], m);
}
  }
}
}
}

