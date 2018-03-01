#!/bin/bash
# Run script for kesch.cscs.ch
export G2G=1
export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=0

module purge
case $1 in
cray)
  source ./modules_cray.env
  ;;
pgi)
  source ./modules_pgi.env
  ;;
*)
  echo "usage ./run.sh compiler  , with compiler=cray or pgi"
  exit 1
  ;;
esac  

module list

echo "-----------------------------------------------"
echo "Running test mpi_openacc: OpenACC + MPI on CPU"
srun -n 2 --gres=gpu:2 -p debug ./mpi_openacc 1000
echo "-----------------------------------------------"
echo "Running test mpi_gather_openacc: OpenACC + MPI on GPU"
ldd mpi_gather_openacc
srun -n 2 --gres=gpu:2 -p debug ./mpi_gather_openacc
