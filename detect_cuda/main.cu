#include <stdio.h>

int main() {
    int nDevices;
    
    cudaGetDeviceCount(&nDevices);
    if (!nDevices)
    {
        printf("No CUDA capable devices found. Check your setup.");
        return 1;
    }

    printf("Detected %d CUDA devices\n", nDevices);
    for (int i = 0; i < nDevices; i++) {
        // Source: https://devblogs.nvidia.com/parallelforall/how-query-device-properties-and-handle-errors-cuda-cc/
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, i);
        printf("Device Number: %d\n", i);
        printf("  Device name: %s\n", prop.name);
        printf("  Memory Clock Rate (KHz): %d\n", prop.memoryClockRate);
        printf("  Memory Bus Width (bits): %d\n", prop.memoryBusWidth);
        printf("  Peak Memory Bandwidth (GB/s): %f\n", 2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
        printf("  Compute Capability: sm_%d%d\n\n", prop.major, prop.minor);
    }
    return 0;
}
