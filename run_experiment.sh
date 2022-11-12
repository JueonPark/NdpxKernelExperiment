#!/bin/bash
MODEL=$1

python make_ndpx_sim_dir.py --model $MODEL

./make_ndpx_sim_env.sh $MODEL

./get_ndpx_sim_result.sh $MODEL