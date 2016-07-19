# PGI Specific flags

# General Flags (add to default)
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Mpreprocess -Kieee -Mfree -Mdclchk")
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Minform=warn -Munixlogical")

# OpenACC flags

if (TARGET_GPU)
#Set CUDA architecture flag
    if (CUDA_ARCH STREQUAL "sm_20")
        set (PGI_ARCH ",cc20")
    elseif (CUDA_ARCH STREQUAL "sm_30")
        set (PGI_ARCH ",cc30")
    elseif (CUDA_ARCH STREQUAL "sm_32")
        set (PGI_ARCH ",cc30")
    elseif (CUDA_ARCH STREQUAL "sm_35")
        set (PGI_ARCH ",cc35")
    elseif (CUDA_ARCH STREQUAL "sm_37")
        set (PGI_ARCH ",cc35")
    elseif (CUDA_ARCH STREQUAL "sm_50")
        set (PGI_ARCH ",cc50")
    endif()
    set (OpenACC_FLAGS "-acc=verystrict -ta=nvidia,nofma${PGI_ARCH} -Minfo=accel -Minline=coe_th_gpu,coe_so_gpu,cloud_diag_scalar")
else()
    set (OpenACC_FLAGS "")
endif()

SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenACC_FLAGS}")


# Release
#SET(CMAKE_Fortran_FLAGS_RELEASE "-O3 -fast -Mvect=noassoc -Minline")
SET(CMAKE_Fortran_FLAGS_RELEASE "-O3 -fast -Mvect=noassoc")

# Debug Options (replace default)
if (TARGET_GPU)
    SET(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -Minline")
else()
    SET(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -C -Mchkfpstk -Mchkptr -Ktrap=fp -traceback")
endif()

# https://cmake.org/pipermail/cmake/2010-November/040951.html
set(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS "-Mcuda")
