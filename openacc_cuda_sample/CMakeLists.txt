# Top Level CMakeLists.txt File
cmake_minimum_required( VERSION 2.8 )
# set the installation prefix
# Note: setting this *before* the project imposes a default that the user is
# able to change.
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/install/" CACHE PATH "installation prefix")

project(COSMO)
enable_language(Fortran)
enable_language(CXX)

find_package( CUDA 5.0 )
set( CUDA_ARCH "sm_35" CACHE STRING "Compute capability for CUDA" )
set( NVCC_FLAGS "-arch=${CUDA_ARCH}" ) # -Xptxas -abi=no

set( TARGET_GPU "ON" )
if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "Cray")
    include(cray.cmake)
    add_definitions("-DCRAY_WORKAROUND")
endif()
if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "PGI")
    include(pgi.cmake)
endif()
if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
    include(gnu.cmake)
endif()

## Unittests

set(FORTRAN_SRC
    src/m_config.f90
    src/m_fields.f90
    src/m_io.f90
    src/m_parameterizations.f90
    src/m_physics.f90
    src/m_setup.f90
    src/m_timing.f90
    src/main.f90
    )
set (C_SRC
    src/saturation_adjustment.cu
    )

cuda_compile(
    CUDA_COMPILED
    ${C_SRC}
    OPTIONS ${NVCC_FLAGS}
    )

add_executable(openacc_cuda_sample
    ${FORTRAN_SRC}
    ${CUDA_COMPILED}
)
target_link_libraries(openacc_cuda_sample stdc++ gcc_eh)
