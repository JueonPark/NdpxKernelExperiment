import os
import sys
import shutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-m', '--model', type=str, help="Model name", required=True)
args = parser.parse_args()

current_path = os.getcwd()
optimizations = ["noopt", "memory", "numbering", "allopt"]

for opt in optimizations:
  trace_path = os.path.join(current_path, "traces", args.model)
  kernels = os.listdir(trace_path)
  opt_trace_path = os.path.join(trace_path, opt)
  os.makedirs(opt_trace_path)

  for kernel in kernels:
    if "_ON_THE_FLY_" in kernel:
      os.remove(os.path.join(trace_path, kernel))
      continue
    if "_NDP_" not in kernel:
      continue
    kernel_opt_name = kernel.split(".traceg_")[1]
    if opt in kernel_opt_name:
      new_kernel_name = kernel.split("_" + opt)[0]
      new_kernel_path = os.path.join(opt_trace_path, new_kernel_name)
      shutil.move(os.path.join(trace_path, kernel), new_kernel_path)