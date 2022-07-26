struct {
  double *b;
} typedef block;

struct {
  block **W, *b;
} typedef layer;

struct {
  block *X;
} typedef data;



void block_mult(block a, block b, block c, int nb);
void block_bias_act(block a, block b, int nb);
void init_data(layer **L, data **Ds, data **Dpl, data **Dpt, int n, int nb, int l);
long usecs ();
void compare_output(block *X1, block *, int n, int nb);

void dgemm_ (char *TRANSA, char *TRANSB,
             int *M, int *N, int *K,
             double *ALPHA,
             double *A, int *LDA,
             double *B, int *LDB,
             double *BETA,
             double *C, int *LDC);

void dlarnv_(int *idist, int *iseed, int *n, double *x);
void dcopy_(int *n, double *x, int *ix, double *y, int *iy);
