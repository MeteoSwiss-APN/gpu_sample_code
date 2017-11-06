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
    module load craype-accel-nvidia60
    CPP="CC -O2 -c"
    FC="ftn -O2 -eZ -ffree -N255 -hnoacc"
    FCACC="ftn -O2 -eZ -ffree -N255 -hacc"
    LDFLAG="-lstdc++ print_a.o"
    ;;
esac

export CPP
export FC
export FCACC
export LDFLAG

echo "Building CRAY tests on $HOSTNAME"

bash ./build_tests.sh
