cmake_minimum_required( VERSION 2.8.11.1 )
project( compute )
enable_language( CXX )

find_package( CUDA 5.0 )
set( SOURCES main.cu )
cuda_add_executable( compute ${SOURCES} )