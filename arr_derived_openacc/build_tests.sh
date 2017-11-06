#!/bin/bash

rm -f print_a.o
set -x
${CPP} print_a.cpp
set +x

echo " --------------------------------------- TEST V1 --------------------------------------- "
echo " "
echo "                ------------------------ CPU ------------------------ "
echo " "
rm -f test_v1_cray_cpu
set -x
${FC} -o test_v1_cray_cpu test_array_derived_type_v1.f90 ${LDFLAG}
set +x
if [ ! -z "${FCACC}" ]; then
  echo "                ------------------------ GPU ------------------------ "
  echo " "
  rm -f test_v1_cray_gpu
  set -x
  ${FCACC} -o test_v1_cray_gpu test_array_derived_type_v1.f90 ${LDFLAG}
  set +x
fi

echo " --------------------------------------- TEST V2 --------------------------------------- "
echo " "
echo "                ------------------------ CPU ------------------------ "
echo " "
rm -f test_v2_cray_cpu
set -x
${FC} -o test_v2_cray_cpu test_array_derived_type_v2.f90 ${LDFLAG}
set +x
if [ ! -z "${FCACC}" ]; then
  echo "                ------------------------ GPU ------------------------ "
  echo " "
  rm -f test_v2_cray_gpu
  set -x
  ${FCACC} -o test_v2_cray_gpu test_array_derived_type_v2.f90 ${LDFLAG}
  set +x
fi

echo " --------------------------------------- TEST V3 --------------------------------------- "
echo " "
echo "                ------------------------ CPU ------------------------ "
echo " "
rm -f test_v3_cray_cpu
set -x
${FC} -o test_v3_cray_cpu test_array_derived_type_v3.f90 ${LDFLAG}
set +x
if [ ! -z "${FCACC}" ]; then
  echo "                ------------------------ GPU ------------------------ "
  echo " "
  rm -f test_v3_cray_gpu
  set -x
  ${FCACC} -o test_v3_cray_gpu test_array_derived_type_v3.f90 ${LDFLAG}
  set +x
fi

echo " --------------------------------------- TEST V4 --------------------------------------- "
echo " "
echo "                ------------------------ CPU ------------------------ "
echo " "
rm -f test_v4_cray_cpu
set -x
${FC} -o test_v4_cray_cpu test_array_derived_type_v4.f90 ${LDFLAG}
set +x
if [ ! -z "${FCACC}" ]; then
  echo "                ------------------------ GPU ------------------------ "
  echo " "
  rm -f test_v4_cray_gpu
  set -x
  ${FCACC} -o test_v4_cray_gpu test_array_derived_type_v4.f90 ${LDFLAG}
  set +x
fi

echo " --------------------------------------- TEST V5 --------------------------------------- "
echo " "
echo "                ------------------------ CPU ------------------------ "
echo " "
rm -f test_v5_cray_cpu
set -x
${FC} -o test_v5_cray_cpu test_array_derived_type_v5.f90 ${LDFLAG}
set +x
if [ ! -z "${FCACC}" ]; then
  echo "                ------------------------ GPU ------------------------ "
  echo " "
  rm -f test_v5_cray_gpu
  set -x
  ${FCACC} -o test_v5_cray_gpu test_array_derived_type_v5.f90 ${LDFLAG}
  set +x
fi

