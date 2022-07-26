#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "aux.h"
#include "omp.h"


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


void init_data(data **datas, resource **resources, int ndatas, int nsteps){

  int d, s;
  
  *datas     = (data*)      malloc(ndatas*sizeof(data));
  *resources = (resource*)  malloc(nsteps*sizeof(resource));

  for (d=0; d<ndatas; d++){
    (*datas)[d].i = -1;
    (*datas)[d].v = d;
  }
  
  for (s=0; s<nsteps; s++){
    (*resources)[s].i    = s;
    (*resources)[s].nr   = nsteps;
    (*resources)[s].busy = -9;
  }

  return;
}




void process_data(data *datas, int d, int s, resource *r){

  double t;
  if(r->busy == -9){
    r->busy = omp_get_thread_num();
    if(r->i != s) {
      printf("Error!!! trying to use resource %d for step %d.\n",r->i,s);
      r->busy = -9;
      return;
    }    
    
    if(datas[d].i == s-1){
      t = 0.2/((double)r->nr);
      mysleep(t);
      datas[d].i = s;
      datas[d].v = datas[d].v*2 + s;
    } else {
      printf("Error!!! trying step %d on data %d but step %d is not done.\n",s,d,s-1);
      r->busy = -9;
      return;
    }
    r->busy = -9;
  } else {
    printf("Error!!! trying to use resource %d but it is busy.\n",r->i);
  }
  
}


void check_result(data *datas, int ndatas, int nsteps){

  int d, s;
  long v;

  
  for (d=0; d<ndatas; d++){
    v = d;
    for (s=0; s<nsteps; s++){
      v = v*2+s;
    }
    if (datas[d].v != v) {
      printf("The result is NOT correct!!!\n");
      return;
    }
      
  }

  printf("The result is correct!!!\n");
  
}
