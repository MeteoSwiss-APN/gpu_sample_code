#!/bin/bash

echo " "
echo " ######################### BUILDING WITH GNU #########################  "
echo " "

COMPILER="gnu"
case $HOSTNAME in
  lothlorien*)
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    FCACC=""
    LDFLAG="-lstdc++ print_a.o"
    gfortran --version
    ;;
  kesch*)
    module purge
    module load craype-haswell PrgEnv-gnu
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    FCACC=""
    LDFLAG="-lstdc++ print_a.o"
    gfortran --version
    ;;
  daint*)
    module load daint-gpu
    module switch PrgEnv-cray PrgEnv-gnu
    module switch gcc/5.3.0 gcc/7.1.0
    module load craype-accel-nvidia60
    CPP="CC -O2 -c"
    FC="ftn -O2 -cpp"
    FCACC="ftn -O2 -fopenacc -cpp"
    LDFLAG="-lstdc++ print_a.o"
    ftn --version
    ;;
esac

export COMPILER
export CPP
export FC
export FCACC
export LDFLAG

echo " "
echo "Building GNU tests on $HOSTNAME"

bash ./build_tests.sh
