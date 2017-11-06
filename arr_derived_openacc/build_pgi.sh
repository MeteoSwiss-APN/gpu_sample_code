#!/bin/bash

echo " "
echo " ######################### BUILDING WITH PGI #########################  "
echo " "

COMPILER="pgi"
case $HOSTNAME in
  lothlorien*)
    export PGI=/usr/local/share/pgi
    export PATH=$PGI/linux86-64/17.4/bin/:$PATH
    export MANPATH=$PGI/linux86-64/17.4/man/:$MANPATH
    export LD_LIBRARY_PATH=$PGI/linux86-64/17.4/lib/:$LD_LIBRARY_PATH
    CPP="pgc++ -g -O2 -c"
    FC="pgf90 -g -Mpreprocess -O2 -Minfo"
    FCACC="${FC} -acc=verystrict -ta=tesla:cc20"
    LDFLAG="-lstdc++ print_a.o"
    ;;
  kesch*)
    module purge
    module load craype-haswell craype-accel-nvidia35 PrgEnv-pgi
    CPP="pgc++ -g -O2 -c"
    FC="pgf90 -g -Mpreprocess -O2 -Minfo"
    FCACC="${FC} -acc=verystrict -ta=tesla:cc35"
    LDFLAG="-lstdc++ print_a.o"
    ;;
  daint*)
    module load daint-gpu
    module switch PrgEnv-cray PrgEnv-pgi
    module load craype-accel-nvidia60
    CPP="CC -g -O2 -c"
    FC="ftn -g -Mpreprocess -O2 -Minfo"
    FCACC="${FC} -acc=verystrict -ta=tesla:cc60"
    LDFLAG="-lstdc++ print_a.o"
    ;;
esac

export COMPILER
export CPP
export FC
export FCACC
export LDFLAG

echo "Building PGI tests on $HOSTNAME"

bash ./build_tests.sh
