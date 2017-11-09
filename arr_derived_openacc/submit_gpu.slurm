#!/bin/bash
#
#SBATCH -t 00:05:00
#SBATCH --gres=gpu:1
#SBATCH --partition=debug

COMPILER="cray"

if [ ${COMPILER} == "pgi" ]; then
  echo "Running PGI GPU tests"
  case $HOSTNAME in
    keschcn*)
      module purge
      module load craype-haswell craype-accel-nvidia35 pgi
      RUNCMD="srun"
      ;;
    kesch*)
      module purge
      module load craype-haswell craype-accel-nvidia35 PrgEnv-pgi
      RUNCMD="srun"
      ;;
    daint*)
      module load daint-gpu
      module switch PrgEnv-cray PrgEnv-pgi
      module load craype-accel-nvidia60
      RUNCMD="srun"
      ;;
    lothlorien*)
      RUNCMD="optirun"
      ;;
  esac
elif [ ${COMPILER} == "gnu" ]; then
  echo "Running GNU GPU tests"
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
      module load craype-accel-nvidia60
      RUNCMD="srun"
      ;;
    lothlorien*)
      RUNCMD="optirun"
      ;;
  esac
else
  echo "Running CRAY GPU tests"
  case $HOSTNAME in
    kesch*)
      module purge
      module load craype-haswell craype-accel-nvidia35 PrgEnv-cray
      RUNCMD="srun"
      ;;
    daint*)
      module load daint-gpu
      module load craype-accel-nvidia60
      RUNCMD="srun"
      ;;
    lothlorien*)
      RUNCMD="optirun"
      ;;
  esac
fi

for v in {1..5}; do
  echo " "
  echo " -------------- V${v} --------------"
  echo " "
  ${RUNCMD} ./test_v${v}_${COMPILER}_gpu 2> /dev/null
  if (( $? > 0 ));then
    echo " RUN: FAILED"
  fi
done
