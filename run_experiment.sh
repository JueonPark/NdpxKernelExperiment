#!/bin/bash
MODEL=$1

python locate_traces.py --model $MODEL

python make_ndpx_sim_dir.py --model $MODEL

./make_ndpx_sim_env.sh $MODEL

./get_ndpx_sim_result.sh $MODEL 1> $MODEL
