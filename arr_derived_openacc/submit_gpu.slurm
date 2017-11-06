#!/bin/bash
#
#SBATCH -t 00:05:00
#SBATCH --gres=gpu:1
#SBATCH --partition=debug
#SBATCH -C gpu
#SBATCH --account=c15

COMPILER="cray"

if [ ${COMPILER} == "pgi" ]; then
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell craype-accel-nvidia35 PrgEnv-pgi
      ;;
    daint*)
      module load daint-gpu
      module switch PrgEnv-cray PrgEnv-pgi
      module load craype-accel-nvidia60
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
      module load craype-accel-nvidia60
      ;;
  esac
else
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell craype-accel-nvidia35 PrgEnv-cray
      ;;
    daint*)
      module load daint-gpu
      module load craype-accel-nvidia60
      ;;
  esac
fi

for v in {1..5}; do
  echo " "
  echo " -------------- V${v} --------------"
  echo " "
  ./test_v${v}_${COMPILER}_gpu
done
