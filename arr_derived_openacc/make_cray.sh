#!/bin/bash

case $HOSTNAME in
  lothlorien*)
    echo "CRAY is not available on $HOSTNAME"
    exit 0
    ;;
  kesch*)
    CPP="CC -O2 -c"
    FC="ftn -O2 -eZ"
    FCACC="${FC} -hacc"
    LDFLAG="-lstdc++ print_a.o"
    ;;
  daint*)
    CPP="CC -O2 -c"
    FC="ftn -O2 -eZ"
    FCACC="${FC} -hacc"
    LDFLAG="-lstdc++ print_a.o"
    ;;
esac

echo "Building CRAY tests on $HOSTNAME"

rm print_a.o
${CPP} print_a.cpp
rm test_v1_pgi_cpu
${FC} -o test_v1_pgi_cpu test_array_derived_type_v1.f90 ${LDFLAG}
rm test_v1_pgi_gpu
${FCACC} -o test_v1_pgi_gpu test_array_derived_type_v1.f90 ${LDFLAG}

rm print_a.o
${CPP} print_a.cpp
rm test_v2_pgi_cpu
${FC} -o test_v2_pgi_cpu test_array_derived_type_v2.f90 ${LDFLAG}
rm test_v2_pgi_gpu
${FCACC} -o test_v2_pgi_gpu test_array_derived_type_v2.f90 ${LDFLAG}
