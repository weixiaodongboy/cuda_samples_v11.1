/*
 * Copyright 1993-2015 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */


// System includes
#include <stdio.h>
#include <assert.h>

// CUDA runtime
#include <cuda_runtime.h>

// helper functions and utilities to work with CUDA
#include <helper_functions.h>
#include <helper_cuda.h>

#ifndef MAX
#define MAX(a,b) (a > b ? a : b)
#endif

__global__ void testKernel(int val)
{
    printf("[%d, %d]:\t\tValue is:%d\n gridDim.x = %d  gridDim.y = %d  blockDim.x = %d  blockDim.y = %d  blockIdx.x = %d  blockIdx.y = %d  \n threadIdx.x = %d threadIdx.y = %d threadIdx.z = %d\n", \
        blockIdx.y * gridDim.x + blockIdx.x, \
        threadIdx.z * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x, \
        val, gridDim.x, gridDim.y, blockDim.x, blockDim.y, blockIdx.x, blockIdx.y, threadIdx.x, threadIdx.y, threadIdx.z);
}

int main(int argc, char **argv)
{
    int devID;
    cudaDeviceProp props;

    // This will pick the best possible CUDA capable device
    devID = findCudaDevice(argc, (const char **)argv);

    //Get GPU information
    checkCudaErrors(cudaGetDevice(&devID));
    checkCudaErrors(cudaGetDeviceProperties(&props, devID));
    printf("Device %d: \"%s\" with Compute %d.%d capability\n",
           devID, props.name, props.major, props.minor);

    printf("printf() is called. Output:\n\n");

    //Kernel configuration, where a two-dimensional grid and
    //three-dimensional blocks are configured.
    dim3 dimGrid(2, 2);
    dim3 dimBlock(2, 2, 2);
    
    printf("[%d, %d]:\t\tValue is:%d\n gridDim.x = %d  gridDim.y = %d  blockDim.x = %d  blockDim.y = %d\n", \
        blockIdx.y * gridDim.x + blockIdx.x, \
        threadIdx.z * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x, \
        val, gridDim.x, gridDim.y, blockDim.x, blockDim.y);

    testKernel<<<dimGrid, dimBlock>>>(10);
    cudaDeviceSynchronize();

    return EXIT_SUCCESS;
}

