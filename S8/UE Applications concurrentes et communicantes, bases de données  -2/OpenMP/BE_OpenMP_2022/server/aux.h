#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>

#define MIN(a,b) (((a)<(b))?(a):(b))
#define MAX(a,b) (((a)>(b))?(a):(b))

#define timelim 1
#define nreq 100000
#define ntypes 4


typedef struct requeststruct{
  int    type;
  int    id;
  double data;
} Request;

typedef struct resultstruct{
  int    type;
  int    id;
  double data;
} Result;


typedef struct stackstruct{
  int head;
  Result results[nreq];
} Stack;



long usecs ();

void init(Stack *bins);
Request receive();
Result process(Request *req);
void check(Stack *stacks);
