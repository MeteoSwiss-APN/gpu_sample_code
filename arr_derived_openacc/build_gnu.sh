#!/bin/bash

case $HOSTNAME in
  lothlorien*)
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    FCACC=""
    LDFLAG="-lstdc++ print_a.o"
    ;;
  kesch*)
    module purge
    module load craype-haswell PrgEnv-gnu
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    FCACC=""
    LDFLAG="-lstdc++ print_a.o"
    ;;
  daint*)
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    FCACC=""
    LDFLAG="-lstdc++ print_a.o"
    ;;
esac

export CPP
export FC
export FCACC
export LDFLAG

echo "Building GNU tests on $HOSTNAME"

bash ./build_tests.sh
