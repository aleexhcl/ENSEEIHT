#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <math.h>
#include <sys/time.h>

#define MIN(a,b) (((a)<(b))?(a):(b))


int operator(int a, int b);
void generate_array(int n, int **array, int *res);
void mysleep(double t);
long usecs ();
void check_result(int n, int *array, int res);

  
