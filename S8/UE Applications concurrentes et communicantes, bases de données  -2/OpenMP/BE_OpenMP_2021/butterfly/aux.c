#include "aux.h"

void generate_array(int n, int **array, int *res){

  int i;
  
  *res = 0;
  
  *array = (int*)malloc(n*sizeof(int));

  for(i=0; i<n; i++){
    (*array)[i] = rand()%10;
    *res+=(*array)[i];
  }

  
}



int operator(int a, int b){
  mysleep(0.0001);
  return a+b;
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




void check_result(int n, int *array, int res){
  int i;

  int ok = 1;
  
  for(i=0; i<n; i++)
    ok = ok && (array[i]==res);

  if(ok){
    printf("The result is CORRECT\n");
  } else {
    printf("The result is WRONG!!!\n");

  }

  
}
