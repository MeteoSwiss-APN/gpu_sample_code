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
  rm -f test_v${v}_${COMPILER}_cpu
  set -x
  ${FC} -o test_v${v}_${COMPILER}_cpu test_array_derived_type_v${v}.f90 ${LDFLAG} >& test_v${v}_${COMPILER}_cpu.build
  set +x
  if [ -f test_v${v}_${COMPILER}_cpu ];then
    echo "               BUILD: SUCCESS"
  else
    echo "               BUILD: FAILED"
  fi
  if [ ! -z "${FCACC}" ]; then
    echo "     ---------------- GPU ---------------- "
    echo " "
    rm -f test_v${v}_${COMPILER}_gpu
    set -x
    ${FCACC} -o test_v${v}_${COMPILER}_gpu test_array_derived_type_v${v}.f90 ${LDFLAG} >& test_v${v}_${COMPILER}_gpu.build
    set +x
    if [ -f test_v${v}_${COMPILER}_gpu ];then
      echo "               BUILD: SUCCESS"
    else
      echo "               BUILD: FAILED"
    fi
  fi
done
