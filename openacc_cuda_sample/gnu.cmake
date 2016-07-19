# Gnu Specific flags

# General Flags (add to default)
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=gnu")
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -cpp -fno-fast-math -ffree-line-length-none")
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree-form -fno-backslash ")
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fimplicit-none -finline-functions")
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wunderflow -Wline-truncation -Waliasing")

# OpenACC flags
if (TARGET_GPU)
#do nothing
endif()

# Release
SET(CMAKE_Fortran_FLAGS_RELEASE "-O3 -ftree-vectorize -funroll-loops")

# Debug Options (replace default)
SET(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -fbacktrace -fdump-core")
SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -ffpe-trap=invalid,zero,overflow")
SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fbounds-check -fcheck-array-temporaries")
SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -finit-integer=-99999999 -finit-real=nan")