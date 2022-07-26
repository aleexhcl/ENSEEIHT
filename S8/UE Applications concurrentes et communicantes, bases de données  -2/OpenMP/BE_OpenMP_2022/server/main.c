#include "aux.h"
#include "omp.h"

int main(int argc, char **argv){
  long    t_start;
  double  time;
  int     i, j, n;
  Stack   stacks[ntypes];
  Request req;
  int     head;
    
  init(stacks);

  t_start=usecs();

#pragma omp parallel 
{
#pragma omp master
{
  for(;;){
    
    req = receive();
    
    /* printf("Received request %d\n",req.id); */
    if(req.type != -1) {
      
      /* process request and push result on stack */
      /* printf("Processing request %d\n",req.id); */
#pragma omp task depend(inout : stacks[req.type]) firstprivate(req)
      stacks[req.type].results[++stacks[req.type].head] = process(&req);
      
    } else {
      break;
    }
    
  }
}
}

  time=(double)(usecs()-t_start)/1000000.0;
  printf("Finished. Execution time:%.2f \n",time);

  check(stacks);
  
  return 0;
}

/* POUR 4 THREADS :

séquentiel : Execution time:1.05 

parallele : Execution time:0.27 

La version parallèle permet d'executer les taches plus de 
deux fois plus vite, c'est donc plus approprié. 

*/