#!/bin/bash

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
    CPP="pgc++ -g -O2 -c"
    FC="pgf90 -g -Mpreprocess -O2 -Minfo"
    FCACC="${FC} -acc=verystrict -ta=tesla:cc20"
    LDFLAG="-lstdc++ print_a.o"
    ;;
  daint*)
    CPP="pgc++ -g -O2 -c"
    FC="pgf90 -g -Mpreprocess -O2 -Minfo"
    FCACC="${FC} -acc=verystrict -ta=tesla:cc20"
    LDFLAG="-lstdc++ print_a.o"
    ;;
esac

echo "Building PGI tests on $HOSTNAME"

rm print_a.o
${CPP} print_a.cpp
rm test_v1_pgi_cpu
${FC} -o test_v1_pgi_cpu test_array_derived_type_v1.f90 ${LDFLAG} >& test_array_derived_type_v1.pgi_cpu.info
rm test_v1_pgi_gpu
${FCACC} -o test_v1_pgi_gpu test_array_derived_type_v1.f90 ${LDFLAG} >& test_array_derived_type_v1.pgi_gpu.info

rm print_a.o
${CPP} print_a.cpp
rm test_v2_pgi_cpu
${FC} -o test_v2_pgi_cpu test_array_derived_type_v2.f90 ${LDFLAG} >& test_array_derived_type_v2.pgi_cpu.info
rm test_v2_pgi_gpu
${FCACC} -o test_v2_pgi_gpu test_array_derived_type_v2.f90 ${LDFLAG} >& test_array_derived_type_v2.pgi_gpu.info
