# OpenACC + CUDA Sample
This is a OpenACC and CUDA sample code to verify the setup of a system.

## Requirements

- NVIDIA GPU with Compute Capability >= 2.1
- CUDA Toolkit 7.0+ with an installation of `nvcc` and associated tools.
- OpenACC 2.0+ Fortran Compiler with GPU support. PGI 16.3+ and Cray 8.4.0a+ are known to work
- CMake with `ccmake`

## Compiling

- Create a build directory

        mkdir build

- Configure the build using cmake:

        export FC=your_fortran_compiler # PGI: export FC=pgfortran
        cmake $SRC_DIR

- Specify the architecture of your graphics card using ccmake:

        ccmake .

  Adapt the settings:

	    # CMAKE_BUILD_TYPE				   Release
	    # CUDA_ARCH                        sm_35	# Based on your graphics card. 
	    											# See https://en.wikipedia.org/wiki/CUDA#GPUs_supported 
	    											# for your compute capability
	    # CUDA_HOST_COMPILER               gcc      # We recommend using gcc


- Run make to build it:

        make

This will create an executable called `openacc_cuda_sample`

## Output

If everything went correctly you should see something like

	Running with OpenACC
	Initialize
	GPU initialized
	Start of time loop
	Step:     20, mean(qv) =    1.14302104E-04
	Step:     40, mean(qv) =    1.34041461E-04
	Step:     60, mean(qv) =    1.53710207E-04
	Step:     80, mean(qv) =    1.73309068E-04
	Step:    100, mean(qv) =    1.92838848E-04
	End of time loop
	----------------------------
	Timers:
	----------------------------
	Initialization :   631.71 ms
	Time loop      :    63.13 ms
	----------------------------

when executing the code.
