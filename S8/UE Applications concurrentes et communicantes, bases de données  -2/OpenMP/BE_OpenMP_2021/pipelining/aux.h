struct {
  int i, nr, busy;
} typedef resource;

struct {
  int i;
  long v;
} typedef data;


long usecs ();
void process_data(data *datas, int d, int s, resource *r);
void init_data(data **datas, resource **resources, int ndatas, int nsteps);
void check_result(data *datas, int ndatas, int nsteps);
