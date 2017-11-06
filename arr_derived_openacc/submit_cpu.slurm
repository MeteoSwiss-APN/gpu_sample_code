#!/bin/bash
#
#SBATCH -t 00:05:00
#SBATCH --partition=debug
#SBATCH -C gpu
#SBATCH --account=c15

COMPILER="cray"

if [ ${COMPILER} == "pgi" ]; then
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell PrgEnv-pgi
      ;;
    daint*)
      module load daint-gpu
      module switch PrgEnv-cray PrgEnv-pgi
      ;;
  esac
elif [ ${COMPILER} == "gnu" ]; then
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell PrgEnv-gnu
      ;;
    daint*)
      module load daint-gpu
      module switch PrgEnv-cray PrgEnv-gnu
      module switch gcc/5.3.0 gcc/7.1.0
      ;;
  esac
else
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell PrgEnv-cray
      ;;
    daint*)
      module load daint-gpu
      ;;
  esac
fi

for v in {1..5}; do
  echo " "
  echo " -------------- V${v} --------------"
  echo " "
  ./test_v${v}_${COMPILER}_cpu
done
