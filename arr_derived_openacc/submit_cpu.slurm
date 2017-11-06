#!/bin/bash
#
#SBATCH -t 00:05:00
#SBATCH --partition=debug
#SBATCH -C gpu
#SBATCH --account=c15

COMPILER="pgi"

if [ ${COMPILER} == "pgi" ]; then
  echo "Running PGI CPU tests"
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell PrgEnv-pgi
      RUNCMD="srun"
      ;;
    daint*)
      module load daint-gpu
      module switch PrgEnv-cray PrgEnv-pgi
      RUNCMD="srun"
      ;;
    lothlorien*)
      RUNCMD=""
      ;;
  esac
elif [ ${COMPILER} == "gnu" ]; then
  echo "Running GNU CPU tests"
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell PrgEnv-gnu
      RUNCMD="srun"
      ;;
    daint*)
      module load daint-gpu
      module switch PrgEnv-cray PrgEnv-gnu
      module switch gcc/5.3.0 gcc/7.1.0
      RUNCMD="srun"
      ;;
    lothlorien*)
      RUNCMD=""
      ;;
  esac
else
  echo "Running CRAY CPU tests"
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell PrgEnv-cray
      RUNCMD="srun"
      ;;
    daint*)
      module load daint-gpu
      RUNCMD="srun"
      ;;
    lothlorien*)
      RUNCMD=""
      ;;
  esac
fi

for v in {1..5}; do
  echo " "
  echo " -------------- V${v} --------------"
  echo " "
  ${RUNCMD} ./test_v${v}_${COMPILER}_cpu 2> /dev/null
  if (( $? > 0 ));then
    echo " RUN: FAILED"
  fi
done
