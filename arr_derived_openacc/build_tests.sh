#!/bin/bash

rm -f print_a.o
#set -x
${CPP} print_a.cpp
#set +x

for v in {1..5};do
  echo " --------------------- TEST V${v} ----------------------- "
  echo " "
  echo "       ---------------- CPU ---------------- "
  echo " "
  rm -f test_v${v}_cray_cpu
  set -x
  ${FC} -o test_v${v}_cray_cpu test_array_derived_type_v${v}.f90 ${LDFLAG} >& test_v${v}_cray_cpu.build
  set +x
  if [ -f test_v${v}_cray_cpu ];then
    echo "                      SUCCESS"
  else
    echo "                      FAILED"
  fi
  if [ ! -z "${FCACC}" ]; then
    echo "     ---------------- GPU ---------------- "
    echo " "
    rm -f test_v${v}_cray_gpu
    set -x
    ${FCACC} -o test_v${v}_cray_gpu test_array_derived_type_v${v}.f90 ${LDFLAG} >& test_v${v}_cray_gpu.build
    set +x
    if [ -f test_v${v}_cray_gpu ];then
      echo "                      SUCCESS"
    else
      echo "                      FAILED"
    fi
  fi
done
