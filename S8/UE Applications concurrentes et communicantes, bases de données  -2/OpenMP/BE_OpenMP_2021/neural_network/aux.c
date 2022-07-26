#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "aux.h"

int     ISEED[4] = {0,0,0,1};
int     IONE=1;
char    NoTran = 'N';
double  DONE=1.0, DMONE=-1.0;
double  alpha=1.0, beta=0.0;

void init_data(layer **L, data **Ds, data **Dpl, data **Dpt, int n, int m, int l){

  int i, j, lay, mm;

  *L   = (layer*) malloc(l*sizeof(layer));
  *Ds  = (data*)  malloc((l+1)*sizeof(data));
  *Dpl = (data*)  malloc((l+1)*sizeof(data));
  *Dpt = (data*)  malloc((l+1)*sizeof(data));

  
  mm = m*m;


  for(lay=0; lay<l; lay++){

    (*L)[lay].W   = (block**)malloc(n*sizeof(block*));
    (*L)[lay].b   = (block* )malloc(n*sizeof(block ));
    (*Ds)[lay].X  = (block* )malloc(n*sizeof(block ));
    (*Dpl)[lay].X = (block* )malloc(n*sizeof(block ));
    (*Dpt)[lay].X = (block* )malloc(n*sizeof(block ));

    for(i=0; i<n; i++){
      ((*L)[lay]).W[i] = (block*)malloc(n*sizeof(block));
      
      ((*L)[lay]).b[i].b   = (double*)malloc(m  *sizeof(double));
      ((*Ds)[lay]).X[i].b  = (double*)malloc(mm*sizeof(double));
      ((*Dpl)[lay]).X[i].b = (double*)malloc(mm*sizeof(double));
      ((*Dpt)[lay]).X[i].b = (double*)malloc(mm*sizeof(double));
      dlarnv_(&IONE, ISEED, &m  , ((*L )[lay]).b[i].b);
      dlarnv_(&IONE, ISEED, &mm, ((*Ds)[lay]).X[i].b);
      dcopy_(&mm, ((*Ds)[lay]).X[i].b, &IONE, ((*Dpl)[lay]).X[i].b, &IONE);
      dcopy_(&mm, ((*Ds)[lay]).X[i].b, &IONE, ((*Dpt)[lay]).X[i].b, &IONE);
      
      for(j=0; j<n; j++){
        ((*L)[lay]).W[i][j].b = (double*)malloc(mm*sizeof(double));
        dlarnv_(&IONE, ISEED, &mm, ((*L)[lay]).W[i][j].b);
      }
    }
  }

  (*Ds)[l].X  = (block* )malloc(n*sizeof(block ));
  (*Dpl)[l].X = (block* )malloc(n*sizeof(block ));
  (*Dpt)[l].X = (block* )malloc(n*sizeof(block ));
  for(i=0; i<n; i++){
    ((*Ds)[l]).X[i].b  = (double*)malloc(mm*sizeof(double));
    ((*Dpl)[l]).X[i].b = (double*)malloc(mm*sizeof(double));
    ((*Dpt)[l]).X[i].b = (double*)malloc(mm*sizeof(double));
    dlarnv_(&IONE, ISEED, &mm, ((*Ds)[l]).X[i].b);
    dcopy_(&mm, ((*Ds)[l]).X[i].b, &IONE, ((*Dpl)[l]).X[i].b, &IONE);
    dcopy_(&mm, ((*Ds)[l]).X[i].b, &IONE, ((*Dpt)[l]).X[i].b, &IONE);
  }

  

}


void block_mult(block a, block b, block c, int m){

  dgemm_(&NoTran, &NoTran, &m, &m, &m,
         &alpha,
         a.b,  &m,
         b.b,  &m,
         &beta,
         c.b,  &m);
    
}

void block_bias_act(block b, block X, int m){
  int i, j;

  for(j=0; j<m; j++)
    for(i=0; i<m; i++)
      X.b[m*j+i] = tanh(X.b[m*j+i]+b.b[i]);
  
}


void compare_output(block *X1, block *X2, int n, int m){
  
  int i, j, k, mm;
  double mx;
  mm = m*m;

  mx = 0.0;
  for(i=0; i<n; i++){
    for(k=0; k<mm; k++){
      if(fabs((X1[i].b)[k]-(X2[i].b)[k])/fabs((X1[i].b)[k]) > mx)
        mx = fabs((X1[i].b)[k]-(X2[i].b)[k])/fabs((X1[i].b)[k]);
    }
  }
  
  printf("The maximum difference on coefficients is %e\n",mx);

}



long usecs (){
  struct timeval t;

  gettimeofday(&t,NULL);
  return t.tv_sec*1000000+t.tv_usec;
}
