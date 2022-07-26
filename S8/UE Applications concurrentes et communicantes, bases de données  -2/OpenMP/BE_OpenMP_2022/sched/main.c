#include "aux.h"
#include "omp.h"

void loop1(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;

  load = 0.0;

#pragma omp parallel 
{
#pragma omp for
  for(i=0; i<n; i++){
    t_start=usecs();
    func1(i,n);
    time_it = (double)(usecs()-t_start);
    load+=time_it;
    if(n<=20) printf("Iteration %6d  of loop 1 took %.2f usecs\n",i, time_it);
  }
}
}


void loop2(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;

  load = 0.0;

#pragma omp parallel
{
#pragma omp master
{
  for(i=0; i<n; i++){
#pragma omp task firstprivate(i)
{
    t_start=usecs();
    func2(i,n);
    time_it = (double)(usecs()-t_start);
    load+=time_it;
    if(n<=20) printf("Iteration %6d  of loop 2 took %.2f usecs\n",i, time_it);
}
  }
}
}
}

void loop3(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;

  load = 0.0;

#pragma omp parallel private(i)
{
#pragma omp for
  for(i=0; i<n; i++){
    t_start=usecs();
    func3(i,n);
    time_it = (double)(usecs()-t_start);
    load+=time_it;
    if(n<=20) printf("Iteration %6d  of loop 3 took %.2f usecs\n",i, time_it);
  }
}
}


int main(int argc, char **argv){
  int    i, j, n;

  // Command line argument
  if ( argc == 2 ) {
    n = atoi(argv[1]);    /* the number of loop iterations */
  } else {
    printf("Usage:\n\n ./main n \n\nwhere n is the number of iterations in the loops\n");
    return 1;
  }

  printf("\n");
  
  loop1(n);
  
  printf("\n");

  loop2(n);
  
  printf("\n");

  loop3(n);
  
  printf("\n");
  
  return 0;
}


/* 
POUR 4 THREADS : 

séquentiel :
./main 10

Iteration      0  of loop 1 took 200000.00 usecs
Iteration      1  of loop 1 took 200000.00 usecs
Iteration      2  of loop 1 took 200000.00 usecs
Iteration      3  of loop 1 took 200000.00 usecs
Iteration      4  of loop 1 took 200000.00 usecs
Iteration      5  of loop 1 took 200000.00 usecs
Iteration      6  of loop 1 took 200000.00 usecs
Iteration      7  of loop 1 took 200000.00 usecs
Iteration      8  of loop 1 took 200000.00 usecs
Iteration      9  of loop 1 took 200000.00 usecs

Iteration      0  of loop 2 took 40000.00 usecs
Iteration      1  of loop 2 took 80000.00 usecs
Iteration      2  of loop 2 took 120000.00 usecs
Iteration      3  of loop 2 took 160000.00 usecs
Iteration      4  of loop 2 took 200000.00 usecs
Iteration      5  of loop 2 took 240000.00 usecs
Iteration      6  of loop 2 took 280000.00 usecs
Iteration      7  of loop 2 took 320000.00 usecs
Iteration      8  of loop 2 took 360000.00 usecs
Iteration      9  of loop 2 took 400000.00 usecs

Iteration      0  of loop 3 took 400000.00 usecs
Iteration      1  of loop 3 took 360000.00 usecs
Iteration      2  of loop 3 took 320000.00 usecs
Iteration      3  of loop 3 took 280000.00 usecs
Iteration      4  of loop 3 took 240000.00 usecs
Iteration      5  of loop 3 took 200000.00 usecs
Iteration      6  of loop 3 took 160000.00 usecs
Iteration      7  of loop 3 took 120000.00 usecs
Iteration      8  of loop 3 took 80000.00 usecs
Iteration      9  of loop 3 took 40000.00 usecs

parallèle : 
./main 10

Iteration      8  of loop 1 took 188491.00 usecs
Iteration      0  of loop 1 took 188492.00 usecs
Iteration      3  of loop 1 took 188491.00 usecs
Iteration      6  of loop 1 took 11382.00 usecs
Iteration      9  of loop 1 took 188519.00 usecs
Iteration      4  of loop 1 took 188611.00 usecs
Iteration      1  of loop 1 took 188558.00 usecs
Iteration      7  of loop 1 took 11321.00 usecs
Iteration      5  of loop 1 took 199946.00 usecs
Iteration      2  of loop 1 took 200001.00 usecs


Iteration      0  of loop 2 took 39985.00 usecs
Iteration      1  of loop 2 took 39997.00 usecs
Iteration      2  of loop 2 took 39998.00 usecs
Iteration      3  of loop 2 took 39999.00 usecs
Iteration      4  of loop 2 took 79943.00 usecs
Iteration      5  of loop 2 took 79971.00 usecs
Iteration      6  of loop 2 took 86531.00 usecs
Iteration      7  of loop 2 took 160020.00 usecs
Iteration      8  of loop 2 took 280013.00 usecs
Iteration      9  of loop 2 took 400000.00 usecs

Iteration      8  of loop 3 took 79999.00 usecs
Iteration      9  of loop 3 took 40000.00 usecs
Iteration      6  of loop 3 took 79992.00 usecs
Iteration      3  of loop 3 took 119996.00 usecs
Iteration      7  of loop 3 took 120000.00 usecs
Iteration      0  of loop 3 took 119989.00 usecs
Iteration      4  of loop 3 took 120002.00 usecs
Iteration      5  of loop 3 took 200000.00 usecs
Iteration      1  of loop 3 took 239994.00 usecs
Iteration      2  of loop 3 took 320000.00 usecs

Pour la première boucle :
les temps pour chaque itération étaient les mêmes, j'ai donc 
choisi de paralléliser sous la forme d'une boucle for en 
parallèle pour que chaque boucle puise être exécutée en 
parallèle des autres. Le temps est globalement le même, sauf
pour une itération qui est plus courte, ce qui rend le rapport 
temps maximum sur minimum assez élevé, de 20 environ.

pour la deuxieme boucle :
Les temps de chaque itération étant de plus en plus élevé à chaque 
augmentation d'itération, j'ai choisi de créer des taches pour que les
actions plus longues puissent être faites pendant que plusieurs 
plus petites sont executées. Le rapport maximum sur minimum est relativement 
le même qu'en séquentiel, de 10, mais le temps de chaque itération est plus 
court.

pour la troisieme boucle :
les temps de chaque itération étant de plus en plus courts, j'ai choisi
au départ d'utiliser des taches, mais l'une des taches étant tres courte en
temps d'éxécution, la parallélisation de la boucle for s'est avérée 
plus efficace, donnant un maximum sur minimum de 4 pour 10 en séquentiel,
les itérations étant exécutées en un temps plus court aussi. 

POUR 2 THREADS :

séquentiel:
./main 5

Iteration      0  of loop 1 took 400000.00 usecs
Iteration      1  of loop 1 took 400000.00 usecs
Iteration      2  of loop 1 took 400000.00 usecs
Iteration      3  of loop 1 took 400000.00 usecs
Iteration      4  of loop 1 took 400000.00 usecs

Iteration      0  of loop 2 took 160000.00 usecs
Iteration      1  of loop 2 took 320000.00 usecs
Iteration      2  of loop 2 took 480000.00 usecs
Iteration      3  of loop 2 took 640000.00 usecs
Iteration      4  of loop 2 took 800000.00 usecs

Iteration      0  of loop 3 took 800000.00 usecs
Iteration      1  of loop 3 took 640001.00 usecs
Iteration      2  of loop 3 took 480000.00 usecs
Iteration      3  of loop 3 took 320000.00 usecs
Iteration      4  of loop 3 took 160000.00 usecs

parallèle:
./main 5

Iteration      0  of loop 1 took 400000.00 usecs
Iteration      3  of loop 1 took 400000.00 usecs
Iteration      1  of loop 1 took 399969.00 usecs
Iteration      4  of loop 1 took 25.00 usecs
Iteration      2  of loop 1 took 400000.00 usecs

Iteration      0  of loop 2 took 160000.00 usecs
Iteration      1  of loop 2 took 159970.00 usecs
Iteration      2  of loop 2 took 320023.00 usecs
Iteration      3  of loop 2 took 319968.00 usecs
Iteration      4  of loop 2 took 800000.00 usecs

Iteration      3  of loop 3 took 320000.00 usecs
Iteration      4  of loop 3 took 160000.00 usecs
Iteration      0  of loop 3 took 479993.00 usecs
Iteration      1  of loop 3 took 640001.00 usecs
Iteration      2  of loop 3 took 480000.00 usecs

pour 2 threads, les boucles en parallele sont plus rapides que les résultats 
en séqeuntiel.


POUR 1 THREAD :
séquentiel:
./main 5

Iteration      0  of loop 1 took 400000.00 usecs
Iteration      1  of loop 1 took 400000.00 usecs
Iteration      2  of loop 1 took 400000.00 usecs
Iteration      3  of loop 1 took 400000.00 usecs
Iteration      4  of loop 1 took 400000.00 usecs

Iteration      0  of loop 2 took 160000.00 usecs
Iteration      1  of loop 2 took 320000.00 usecs
Iteration      2  of loop 2 took 480000.00 usecs
Iteration      3  of loop 2 took 640000.00 usecs
Iteration      4  of loop 2 took 800000.00 usecs

Iteration      0  of loop 3 took 800000.00 usecs
Iteration      1  of loop 3 took 640000.00 usecs
Iteration      2  of loop 3 took 480000.00 usecs
Iteration      3  of loop 3 took 320000.00 usecs
Iteration      4  of loop 3 took 160000.00 usecs

parallele :
./main 5

Iteration      0  of loop 1 took 400000.00 usecs
Iteration      1  of loop 1 took 400000.00 usecs
Iteration      2  of loop 1 took 400000.00 usecs
Iteration      3  of loop 1 took 400000.00 usecs
Iteration      4  of loop 1 took 400000.00 usecs

Iteration      0  of loop 2 took 160000.00 usecs
Iteration      1  of loop 2 took 320000.00 usecs
Iteration      2  of loop 2 took 480000.00 usecs
Iteration      3  of loop 2 took 640000.00 usecs
Iteration      4  of loop 2 took 800000.00 usecs

Iteration      0  of loop 3 took 800000.00 usecs
Iteration      1  of loop 3 took 640000.00 usecs
Iteration      2  of loop 3 took 480000.00 usecs
Iteration      3  of loop 3 took 320000.00 usecs
Iteration      4  of loop 3 took 160000.00 usecs

les résultats sont exactement des mêmes pour 1 thread 
(ce qui est cohérent)

*/