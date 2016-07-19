# Detecting CUDA
This code allows detecting whether a system has been setup correctly for CUDA to work. It also allows to determine the CUDA compute capability.

The device detection code was copied from the respective blog entry on the [NVIDIA website](https://devblogs.nvidia.com/parallelforall/how-query-device-properties-and-handle-errors-cuda-cc/)

## Requirements

- An installation of the CUDA toolkit with `nvcc`
- A C/C++ compiler
- Optionally: CMake

## Compilation

### Direct

    nvcc -o detect_cuda main.cu

### CMake

    cmake $SRC_DIR
    make 

## Running the code

Simply execute the generated binary `detect_cuda`:

    ./detect_cuda

If everything went well the output should look similar to this:

    Detected 1 CUDA devices
	Device Number: 0
	  Device name: Tesla K80
	  Memory Clock Rate (KHz): 2505000
	  Memory Bus Width (bits): 384
	  Peak Memory Bandwidth (GB/s): 240.480000
	  Compute Capability sm_37

