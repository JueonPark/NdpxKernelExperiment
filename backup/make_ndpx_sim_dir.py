import os
import sys
import shutil

GPU_TRACE = "example_gpu_kernel.traceg"
CUDA_SYNC = 'cudaDeviceSynchronize 0'

current_path = os.getcwd()
gpu_kernel_path = os.path.join(current_path, "example_gpu_kernel.traceg")
optimized_path = os.path.join(current_path, "optimized_kernels")
unoptimized_path = os.path.join(current_path, "unoptimized_kernels")
optimized_kernels = os.listdir(optimized_path)
unoptimized_kernels = os.listdir(unoptimized_path)

for kernel in optimized_kernels:
  if "_ON_THE_FLY_" in kernel:
    continue
  kerneldir_name = kernel.split("_0_")[0]
  kerneldir_path = os.path.join(optimized_path, kerneldir_name)
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
  ndpx_kernel_path = os.path.join(optimized_path, kernel)
  new_ndpx_kernel_path = os.path.join(gpu_0_path, kernel)
  shutil.move(ndpx_kernel_path, new_ndpx_kernel_path)
  new_gpu_kernel_path = os.path.join(gpu_0_path, GPU_TRACE)
  os.symlink(gpu_kernel_path, new_gpu_kernel_path)

for kernel in unoptimized_kernels:
  if "_ON_THE_FLY_" in kernel:
    continue
  kerneldir_name = kernel.split("_0_")[0]
  kerneldir_path = os.path.join(unoptimized_path, kerneldir_name)
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
  ndpx_kernel_path = os.path.join(unoptimized_path, kernel)
  new_ndpx_kernel_path = os.path.join(gpu_0_path, kernel)
  shutil.move(ndpx_kernel_path, new_ndpx_kernel_path)
  new_gpu_kernel_path = os.path.join(gpu_0_path, GPU_TRACE)
  os.symlink(gpu_kernel_path, new_gpu_kernel_path)
