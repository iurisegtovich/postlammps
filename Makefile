DEBUG ?= 0

FORT    ?= gfortran

BASIC_F_OPTS = -g -cpp -Wunused -fmax-errors=1

# Option FAST (default):
FAST_F_OPTS = -O3 -march=native -ffast-math -funroll-loops -fstrict-aliasing

# Option DEBUG:
DEBUG_F_OPTS = -Wall -Wno-maybe-uninitialized -Og -fcheck=all -Ddebug


ifeq ($(DEBUG), 1)
  FOPTS = $(BASIC_F_OPTS) $(DEBUG_F_OPTS)
else
  FOPTS = $(BASIC_F_OPTS) $(FAST_F_OPTS)
endif

all: postlammps

clean:
	rm -rf *.o
	rm -rf *.mod
	rm -rf postlammps

install:
	cp -f ./postlammps /usr/local/bin/

postlammps: postlammps.f90 mData_Proc.o mProp_List.o mProp_List.o mString.o
	$(FORT) $(FOPTS) -o $@ $^

mData_Proc.o: mData_Proc.f90 mProp_List.o
	$(FORT) $(FOPTS) -c -o $@ $<

mProp_List.o: mProp_List.f90 mConstants.o
	$(FORT) $(FOPTS) -c -o $@ $<

mString.o: mString.f90 mConstants.o
	$(FORT) $(FOPTS) -c -o $@ $<

mConstants.o: mConstants.f90
	$(FORT) $(FOPTS) -c -o $@ $<

