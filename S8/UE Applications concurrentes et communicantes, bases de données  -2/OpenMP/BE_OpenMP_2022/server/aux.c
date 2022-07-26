#include "aux.h"


Request reqs[nreq];
int rc;

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


void init(Stack *bins){

  int i;

  for(i=0; i<nreq; i++){
    reqs[i].type = rand() % ntypes;
    reqs[i].data = 2.0*((double)rand() / (double)RAND_MAX) * timelim / ((double)(nreq));
    reqs[i].id   = i;
  }

  rc = 0;

  for(i=0; i<ntypes; i++)
    bins[i].head = -1;
  
}
  

Request receive(){
  Request r;

  if(rc < nreq){
    return reqs[rc++];
  } else {
    r.type = -1;
    r.id   = -999;
    return r;
  }

}

Result process(Request *req){

  Result res;
  
  mysleep(req->data);

  res.type = req->type; 
  res.data = req->data; 
  res.id   = req->id  ; 
  
}


void check(Stack *stacks){

  int cnts[ntypes];
  int i;
  
  for(i=0; i<ntypes;i++)
    cnts[i]=0;

  for(i=0; i<nreq;i++)
    cnts[reqs[i].type]++;

  for(i=0; i<ntypes;i++){
    /* printf("---> %2d %2d\n",cnts[i],stacks[i].head); */
    if(stacks[i].head!=cnts[i]-1){
      printf("Result is wrong :-(\n");
      return;
    }
  }
    
  printf("Result is correct :-)\n");
  return;
  
}
