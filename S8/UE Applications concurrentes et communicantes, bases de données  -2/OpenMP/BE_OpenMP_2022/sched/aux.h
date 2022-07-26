#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>

#define MIN(a,b) (((a)<(b))?(a):(b))
#define MAX(a,b) (((a)>(b))?(a):(b))

long usecs ();
void func1(int i, int n);
void func2(int i, int n);
void func3(int i, int n);
