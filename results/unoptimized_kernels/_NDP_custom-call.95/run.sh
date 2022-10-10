#!/bin/bash            
cp -r /home/jueonpark/cxl-simulator/multi_gpu_simulator/gpu-simulator/gpgpu-sim/lib/gcc-7.3.0/cuda-10010/release/ .            
cp /home/jueonpark/cxl-simulator/multi_gpu_simulator/gpu-simulator/bin/release/accel-sim.out .            
export LD_LIBRARY_PATH=`pwd`/release:$LD_LIBRARY_PATH            
./accel-sim.out -trace /home/jueonpark/ksc2022//unoptimized_kernels/_NDP_custom-call.95/ -config /home/shared/CXL_memory_buffer/ASPLOS_simulator/cxl-simulator/sim_configs/GPU_1_Buffer_1/NDPX_baseline_64/gpgpusim.config -config /home/shared/CXL_memory_buffer/ASPLOS_simulator/cxl-simulator/sim_configs/GPU_1_Buffer_1/NDPX_baseline_64/trace.config -cxl_config /home/shared/CXL_memory_buffer/ASPLOS_simulator/cxl-simulator/sim_configs/GPU_1_Buffer_1/NDPX_baseline_64/cxl.config -num_gpus 1 -num_cxl_memory_buffers 1
