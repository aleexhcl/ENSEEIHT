
struct {
  int i, j;
  double sv;
} typedef synapse;

struct {
  double nv;
} typedef neuron;


struct {
  int m;
  synapse *syn;
  neuron  *neu;
} typedef layer;

void init(layer *layers, int n, int L);
double update(double nin, double v);
void copy_nn(layer *layers_in, layer *layers_out, int n, int L);
long usecs ();
void check_result(layer *layers_s, layer *layers_p, int n, int L);
