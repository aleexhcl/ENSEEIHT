#include "aux.h"
#include "omp.h"

double norm1(double **A, int m, int n);
double norm1_colmajor(double **A, int m, int n);
double norm1_rowmajor(double **A, int m, int n);


int main(int argc, char **argv){
  long   t_start, t_end;
  int    m, n, i, j;
  double nrm, nrmrm, nrmcm;
  double **A;

  // Command line argument: matrix size
  if ( argc == 3 ) {
    m = atoi(argv[1]);    /* the number of matrix rows */
    n = atoi(argv[2]);    /* the number of matrix cols */
  } else {
    printf("Usage:\n\n ./main n m\n\nwhere m and n are the number of rows and cols in the matrix\n");
    return 1;
  }

  A = (double**)malloc(m*sizeof(double*));
  for(i=0; i<m; i++) {
    A[i] = (double*)malloc(n*sizeof(double));
    
    for(j=0; j<n; j++) {
      A[i][j] = ((double)rand() / (double)RAND_MAX);
    }
  }

  /* warm up */
  nrm=norm1(A, m, n);
  

  t_start=usecs();
  nrm=norm1(A, m, n);
  t_end=usecs()-t_start;
  printf("Sequential  --  norm:%8.4f   time (usecs):%6ld\n",nrm,t_end);

  t_start=usecs();
  nrmcm=norm1_colmajor(A, m, n);
  t_end=usecs()-t_start;
  printf("Col-major   --  norm:%8.4f   time (usecs):%6ld\n",nrmcm,t_end);

  t_start=usecs();
  nrmrm=norm1_rowmajor(A, m, n);
  t_end=usecs()-t_start;
  printf("Row-major   --  norm:%8.4f   time (usecs):%6ld\n",nrmrm,t_end);

  
  
  
  printf("\n");
  

  return 0;
}


double norm1(double **A, int m, int n){
  int i, j;
  double nrm, tmp;
  nrm = 0.0;
  
  for(j=0; j<n; j++) {
    tmp = 0.0;
    for(i=0; i<m; i++) {
      tmp += fabs(A[i][j]);
    }
    if(tmp>nrm)
      nrm = tmp;
  }

  return nrm;

}




double norm1_colmajor(double **A, int m, int n){
  int i, j;
  double nrm, tmp;
  nrm = 0.0;

#pragma omp parallel private(j)
{

  for(j=0; j<n; j++) {
    tmp = 0.0;
#pragma omp for reduction(+: tmp)
    for(i=0; i<m; i++) {
      tmp += fabs(A[i][j]);
    }

    if(tmp>nrm)
      nrm = tmp;
  }
}

  return nrm;

}






double norm1_rowmajor(double **A, int m, int n){
  int i, j;
  double nrm, *tmp;
  
  nrm = 0.0;
  tmp = (double*)malloc(n*sizeof(double));
  for(j=0; j<n; j++) 
    tmp[j]=0.0;

#pragma omp parallel private(i)
{
  for(i=0; i<m; i++) {
#pragma omp for 
    for(j=0; j<n; j++) {
      tmp[j] += fabs(A[i][j]);
    }
  }
  
  for(j=0; j<n; j++) 
    if(tmp[j]>nrm)
      nrm = tmp[j];
}

  free(tmp);
  
  return nrm;
  
}


/* POUR 4 THREADS :
./main 5000 3000
Sequential  --  norm:2575.9411   time (usecs): 77760
Col-major   --  norm:2575.9411   time (usecs): 14651
Row-major   --  norm:2575.9411   time (usecs):  5817

./main 3000 5000
Sequential  --  norm:1553.5867   time (usecs): 90751
Col-major   --  norm:1553.5867   time (usecs): 12969
Row-major   --  norm:1553.5867   time (usecs):  5268

Avec 4 threads, la version parallèle est plus rapide pour des n et m grands, et on observe
que la version avec la parallélisation sur les lignes est plus efficace que la
parallélisation sur les colonnes.

POUR 2 THREADS : 
./main 5000 3000
Sequential  --  norm:2575.9411   time (usecs): 78590
Col-major   --  norm:2575.9411   time (usecs): 39421
Row-major   --  norm:2575.9411   time (usecs):  7395

./main 3000 5000
Sequential  --  norm:1553.5867   time (usecs): 92730
Col-major   --  norm:1553.5867   time (usecs): 35067
Row-major   --  norm:1553.5867   time (usecs):  7617

Il en est de même pour 2 threads, les programmes en parallèle sont plus lents que ceux 
avec 4 threads ce qui est cohérent 

POUR 1 THREAD : 
./main 5000 3000
Sequential  --  norm:2575.9411   time (usecs): 78310
Col-major   --  norm:2575.9411   time (usecs): 81497
Row-major   --  norm:2575.9411   time (usecs):  9921

./main 3000 5000
Sequential  --  norm:1553.5867   time (usecs): 91057
Col-major   --  norm:1553.5867   time (usecs): 96061
Row-major   --  norm:1553.5867   time (usecs):  9339

Pour la version avec un thread, la version parallèle sur les colonnes est presque la même 
que la version séquentielle, et la version sur les lignes est plus rapide pour le calcul 
que les deux autres 

*/
