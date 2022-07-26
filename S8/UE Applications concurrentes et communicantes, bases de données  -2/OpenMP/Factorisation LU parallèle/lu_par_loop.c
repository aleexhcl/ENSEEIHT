#include "trace.h"
#include "common.h"
#include <omp.h>


/* This routine performs the LU factorization of a square matrix by
   block-columns */

void lu_par_loop(Matrix A, info_type info){

  int i, j;

  /* Initialize the tracing system */
  trace_init();
  
  /* pas possible de paralelliser cette opération 
  car dépendance entre les différents niveaux consécutifs */

  
#pragma omp parallel private(i) 
/*empeche d'avoir plusieurs incrémentations de i, i propre a chaque processus */

{
  for(i=0; i<info.NB; i++){
    
    /* Do the Panel operation on column i */
    #pragma omp single /* ou master avec ajout de barriere */
    {
    panel(A[i], i, info);
    }

    /* Parallelize this loop  */
    /* #pragma omp parallel for > creation de plusieurs region parallele*/

    #pragma omp for
    for(j=i+1; j<info.NB; j++){
      /* Update column j with respect to the result of panel(A, i) */
      update(A[i], A[j], i, j, info);
    }

  }
}
  
  /* This routine applies permutations resulting from numerical
     pivoting. It has to be executed sequentially. */
  backperm(A, info);
  
  /* Write the trace in file (ignore) */
  trace_dump("trace_par_loop.svg");

  /* trace : pas le meme temps pour chaque opé + panel non parallel d'ou existence
  de moment ou les processus n'executent rien */
  
  return;
  
}
