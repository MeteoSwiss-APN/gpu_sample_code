#!/bin/bash
module purge
echo "source ./modules_cray.env"
source ./modules_cray.env
set -x
ftn -hacc -eZ -o mpi_openacc mpi_openacc.f90
ftn -hacc -eZ -DMPI_MVAPICH -o mpi_gather_openacc mpi_gather_openacc.f90
