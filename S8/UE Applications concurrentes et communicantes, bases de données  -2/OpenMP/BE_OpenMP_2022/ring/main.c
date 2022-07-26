#include "aux.h"
#include "omp.h"


int main(int argc, char **argv){
  long t_start, t_end;
  int  l, t, L, T;
  Token token;
  
  if ( argc == 3 ) {
    L = atoi(argv[1]);    /* number of loops */
    T = atoi(argv[2]);    /* number of threads */
  } else {
    printf("Usage:\n\n ./main L T\n\nsuch that L is the number of loops and T the number of threads to use.\n");
    return 1;
  }

  init(&token, L, T);

#pragma omp parallel num_threads(T) 
{
#pragma omp master 
{
  for(l=0; l<L; l++){
    t = 0;
    printf("Loop %2d\n",l);
    for(t=0;t<T;t++){
#pragma omp task if(omp_get_thread_num() != t) firstprivate(t) untied
{
      while (omp_get_thread_num() != t) {}
      process(&token);
}    
    }
    #pragma omp taskwait
  }
}
}
  check(&token, L, T);
  
  return 0;
}
