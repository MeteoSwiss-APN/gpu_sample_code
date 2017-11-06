#!/bin/bash

case $HOSTNAME in
  lothlorien*)
    echo "CRAY is not available on $HOSTNAME"
    exit 0
    ;;
  kesch*)
    module purge
    module load craype-haswell craype-accel-nvidia35 PrgEnv-cray
    CPP="CC -O2 -c"
    FC="ftn -O2 -eZ -ffree -N255 -en -hnoacc"
    FCACC="ftn -O2 -eZ -ffree -N255 -en -hacc"
    LDFLAG="-lstdc++ print_a.o"
    ;;
  daint*)
    CPP="CC -O2 -c"
    FC="ftn -O2 -eZ -ffree -N255 -hnoacc"
    FCACC="ftn -O2 -eZ -ffree -N255 -hacc"
    LDFLAG="-lstdc++ print_a.o"
    ;;
esac

echo "Building CRAY tests on $HOSTNAME"

rm print_a.o
${CPP} print_a.cpp
rm test_v1_cray_cpu
${FC} -o test_v1_cray_cpu test_array_derived_type_v1.f90 ${LDFLAG}
rm test_v1_cray_gpu
${FCACC} -o test_v1_cray_gpu test_array_derived_type_v1.f90 ${LDFLAG}

rm print_a.o
${CPP} print_a.cpp
rm test_v2_cray_cpu
${FC} -o test_v2_cray_cpu test_array_derived_type_v2.f90 ${LDFLAG}
rm test_v2_cray_gpu
${FCACC} -o test_v2_cray_gpu test_array_derived_type_v2.f90 ${LDFLAG}

rm print_a.o
${CPP} print_a.cpp
rm test_v3_cray_cpu
${FC} -o test_v3_cray_cpu test_array_derived_type_v3.f90 ${LDFLAG}
rm test_v3_cray_gpu
${FCACC} -o test_v3_cray_gpu test_array_derived_type_v3.f90 ${LDFLAG}

rm print_a.o
${CPP} print_a.cpp
rm test_v4_cray_cpu
${FC} -o test_v4_cray_cpu test_array_derived_type_v4.f90 ${LDFLAG}
rm test_v4_cray_gpu
${FCACC} -o test_v4_cray_gpu test_array_derived_type_v4.f90 ${LDFLAG}

rm print_a.o
${CPP} print_a.cpp
rm test_v5_cray_cpu
${FC} -o test_v5_cray_cpu test_array_derived_type_v5.f90 ${LDFLAG}
rm test_v5_cray_gpu
${FCACC} -o test_v5_cray_gpu test_array_derived_type_v5.f90 ${LDFLAG}
