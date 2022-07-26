#include "aux.h"
#include "omp.h"

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


void process(Token *token){

  token->data = token->data*2+omp_get_thread_num();
  mysleep(0.2);
  printf("  -- Thread:%2d\n",omp_get_thread_num());
  /* printf("  -- Thread:%2d   %3d\n",omp_get_thread_num(),token->data); */
  return;
}



void init(Token *token, int L, int T){

  token->data=0;

  return;
}


void check(Token *token, int L, int T){

  int data=0;
  int l, t;
  
  for(l=0; l<L; l++)
    for(t=0; t<T; t++)
      data=data*2+t;


  if(data==token->data){
    printf("The result is good :-)\n");
    /* printf("The result is good :-)   %3d  %3d\n",data,token->data); */
  } else {
    printf("The result is wrong :-)\n");
    /* printf("The result is wrong :-)   %3d  %3d\n",data,token->data); */
  }
  
  return;
}
