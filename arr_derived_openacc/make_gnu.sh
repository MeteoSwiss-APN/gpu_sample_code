#!/bin/bash

case $HOSTNAME in
  lothlorien*)
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    LDFLAG="-lstdc++ print_a.o"
    ;;
  kesch*)
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    LDFLAG="-lstdc++ print_a.o"
    ;;
  daint*)
    CPP="g++ -O2 -c"
    FC="gfortran -O2 -cpp"
    LDFLAG="-lstdc++ print_a.o"
    ;;
esac

echo "Building GNU tests on $HOSTNAME"

rm print_a.o
${CPP} print_a.cpp
rm test_v1_gnu_cpu
${FC} -o test_v1_gnu_cpu test_array_derived_type_v1.f90 ${LDFLAG}

rm print_a.o
${CPP} print_a.cpp
rm test_v2_gnu_cpu
${FC} -o test_v2_gnu_cpu test_array_derived_type_v2.f90 ${LDFLAG}
