#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "aux.h"

#define maxs 0.2
#define mins 0.1

int     ISEED[4] = {0,0,0,1};
int     IONE=1;
char    NoTran = 'N';
double  DONE=1.0, DMONE=-1.0;


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


void init(layer *layers, int n, int L){
  
  int l, i, m, minm, maxm;
  
  minm = (int)((double)(n*n)*mins);
  maxm = (int)((double)(n*n)*(maxs-mins));
  
  for(l=0; l<L; l++) {
    /* fill neurons */
    layers[l].neu = (neuron*) malloc(sizeof(neuron)*n);
    for(i=0; i<n; i++) {
      layers[l].neu[i].nv = 2.0*(double)rand() / ((double)RAND_MAX);
    }
  
    /* fill synapses */
    m = minm+rand()%maxm;
    layers[l].m = m;
    layers[l].syn = (synapse*)malloc(sizeof(synapse)*m);
    /* printf("layer %d -- m:%4d\n",l, m); */
    for(i=0; i<m; i++){
      layers[l].syn[i].i  = rand()%n;
      layers[l].syn[i].j  = rand()%n;
      layers[l].syn[i].sv = 2.0*(double)rand() / ((double)RAND_MAX);
      /* printf("      i:%4d  j:%4d   v:%6.4f\n", */
             /* layers[l].syn[i].i, */
             /* layers[l].syn[i].j, */
             /* layers[l].syn[i].sv); */
    }
  }
  

}

void copy_nn(layer *layers_in, layer *layers_out, int n, int L){
  int l, i, m;
  
  for(l=0; l<L; l++) {
    /* fill neurons */
    layers_out[l].neu = (neuron*) malloc(sizeof(neuron)*n);
    for(i=0; i<n; i++) {
      layers_out[l].neu[i].nv = layers_in[l].neu[i].nv;
    }
  
    /* fill synapses */
    m = layers_in[l].m;
    layers_out[l].m = m;
    layers_out[l].syn = (synapse*)malloc(sizeof(synapse)*m);

    for(i=0; i<m; i++){
      layers_out[l].syn[i].i  = layers_in[l].syn[i].i; 
      layers_out[l].syn[i].j  = layers_in[l].syn[i].j; 
      layers_out[l].syn[i].sv = layers_in[l].syn[i].sv; 
    }
  }
  

}





double update(double nv, double sv){

  mysleep(sv/200);
  
  return nv*sv;

}


void check_result(layer *layers_s, layer *layers_p, int n, int L){

  int i;
  double max;

  max=0.0;
  
  for(i=0; i<n; i++){
    if((layers_s[L-1].neu[i].nv-layers_p[L-1].neu[i].nv)/layers_s[L-1].neu[i].nv > max)
      max = (layers_s[L-1].neu[i].nv-layers_p[L-1].neu[i].nv)/layers_s[L-1].neu[i].nv; 
    /* printf("%.2e\n",(layers_s[L-1].neu[i].nv-layers_p[L-1].neu[i].nv)/layers_s[L-1].neu[i].nv); */
  }

  if(max>1e-12) {
    printf("Result is wrong :-(\n");
  } else {
    printf("Result is correct :-)\n");
  }
}



long usecs (){
  struct timeval t;

  gettimeofday(&t,NULL);
  return t.tv_sec*1000000+t.tv_usec;
}
