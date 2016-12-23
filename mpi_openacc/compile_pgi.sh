#!/bin/bash
mpif90 -ta=nvidia -Mpreprocess -o mpi_openacc mpi_openacc.f90
