"""
append the data to given path
"""
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-m', '--model', type=str, help="model name", required=True)
parser.add_argument('-o', '--output', type=str, help="output path", required=True)
args = parser.parse_args()

current_path = os.getcwd()
optimizations = ["memory", "allopt"]

for opt in optimizations:
  result_path = \
      os.path.join(current_path, "csv_files", f"{args.model}-{opt}.csv")
  
  results = open(result_path, "r").readlines()
  output = open(args.output, "a")

  for result in results[1:]:
    split_result = result.split(",")
    if "NOT" in split_result[5]:
      continue
    output.write(f"{split_result[1]},{split_result[2]},{split_result[3]},{split_result[4]},{split_result[5]}\n")
