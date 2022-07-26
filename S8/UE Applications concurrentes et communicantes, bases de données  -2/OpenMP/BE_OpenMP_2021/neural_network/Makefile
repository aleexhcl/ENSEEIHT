CC       = gcc
LINK     = $(CC)

CFLAGS   = -O3 -fopenmp -Wunknown-pragmas
# CFLAGS   = -g -fopenmp
LDFLAGS  = $(CFLAGS) 
LBLAS    = /mnt/n7fs/ens/tp_abuttari/acml-4.4.0/gfortran64/lib/libacml.a -lm
LIBS     = -lm $(LBLAS) -lm -lgfortran

OBJS =   aux.o main.o

main: $(OBJS)
	$(LINK) -o $@  $(LDFLAGS) $(OBJS) $(LIBS)


clean:
	(rm -f *.o main)



%.o: %.c
	$(CC)  $(CFLAGS)  $(CINCLUDES) $(INCLUDES) $(CDEFS) $(PREC) -c $<
%.o: %.f90				       
	$(FC)  $(FCFLAGS) $(FINCLUDES) $(INCLUDES) $(FDEFS) $(DEFINE_PREPEND)$(PREC) -c $<




