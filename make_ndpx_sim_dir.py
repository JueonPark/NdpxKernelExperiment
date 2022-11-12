import os
import sys
import shutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-m', '--model', type=str, help="Model name", required=True)
args = parser.parse_args()

GPU_TRACE = "example_gpu_kernel.traceg"
CUDA_SYNC = 'cudaDeviceSynchronize 0'

current_path = os.getcwd()
gpu_kernel_path = os.path.join(current_path, "example_gpu_kernel.traceg")
optimizations = ["noopt", "memory", "numbering", "allopt"]

for opt in optimizations:
  kernel_path = os.path.join(current_path, "traces", args.model, opt)
  kernels = os.listdir(kernel_path)

  for kernel in kernels:
    if "_ON_THE_FLY_" in kernel:
      continue
    kerneldir_name = kernel.split(".traceg")[0]
    kerneldir_path = os.path.join(kernel_path, kerneldir_name)
    os.makedirs(kerneldir_path, exist_ok=True)
    # write initial kernelslist.g file
    kernelslist_base_file_path = os.path.join(kerneldir_path, "kernelslist.g")
    kernelslist_base_file = open(kernelslist_base_file_path, "w+")
    kernelslist_base_file.write(GPU_TRACE + '\n')
    kernelslist_base_file.write(CUDA_SYNC)
    kernelslist_base_file.close()
    # make GPU_0 directory
    gpu_0_path = os.path.join(kerneldir_path, "GPU_0")
    os.makedirs(gpu_0_path, exist_ok=True)
    # write kernelslist.g inside GPU_0
    kernelslist_file_path = os.path.join(gpu_0_path, "kernelslist.g")
    kernelslist_file = open(kernelslist_file_path, "w+")
    kernelslist_file.write(kernel + '\n')
    kernelslist_file.write(GPU_TRACE)
    kernelslist_file.close()
    # move the kernel file to GPU_0 directory
    ndpx_kernel_path = os.path.join(kernel_path, kernel)
    new_ndpx_kernel_path = os.path.join(gpu_0_path, kernel)
    shutil.move(ndpx_kernel_path, new_ndpx_kernel_path)
    new_gpu_kernel_path = os.path.join(gpu_0_path, GPU_TRACE)
    os.symlink(gpu_kernel_path, new_gpu_kernel_path)