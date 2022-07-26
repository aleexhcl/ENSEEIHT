#include "aux.h"

#define timelim 2.0


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



void func1(int i, int n){
  double x = timelim/((double)n);
  mysleep(x);

};


void func2(int i, int n){
  /* double x = 2.0*((double)rand() / (double)RAND_MAX) * timelim / ((double)(n)); */
  /* mysleep(x); */

  double x = 2.0*timelim/ ((double)(n*n));
  
  mysleep(((double)(i+1))*x);
  
};



void func3(int i, int n){

  double x = 2.0*timelim/ ((double)(n*n));
  
  mysleep(((double)(n-i))*x);

};

  
