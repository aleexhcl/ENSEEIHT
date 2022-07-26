#!/bin/bash

export LBLAS="/mnt/n7fs/ens/tp_abuttari/acml-4.4.0/gfortran64/lib/libacml.a -lgfortran -lm"
export PATH=/mnt/n7fs/ens/tp_abuttari/opt/gcc-9.2.0/bin/:$PATH;
export LD_LIBRARY_PATH=/mnt/n7fs/ens/tp_abuttari/opt/gmp-6.2.1/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/mnt/n7fs/ens/tp_abuttari/opt/mpfr-4.1.0/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/mnt/n7fs/ens/tp_abuttari/opt/mpc-1.2.0/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/mnt/n7fs/ens/tp_abuttari/opt/gcc-9.2.0/lib64/:$LD_LIBRARY_PATH
