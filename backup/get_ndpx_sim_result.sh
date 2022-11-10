#!/bin/bash

RESUBMIT=1

SIMULATOR_DIR=/home/jueonpark/cxl-simulator
SIMULATOR_BINARY_DIR=$SIMULATOR_DIR/multi_gpu_simulator/gpu-simulator/bin/release

OPT_TRACE_DIR=`pwd`/"optimized_kernels"
UNOPT_TRACE_DIR=`pwd`/"/unoptimized_kernels"
OPT_RESULT_DIR=`pwd`"/results/optimized_kernels"
UNOPT_RESULT_DIR=`pwd`"/results/unoptimized_kernels"

CSV_FILES=`pwd`/csv_files
OPT_CSV_PATH=$CSV_FILES/optimized_kernels.csv
UNOPT_CSV_PATH=$CSV_FILES/unoptimized_kernels.csv

echo "NAME,LINES,SHAPE,CYCLE" > $OPT_CSV_PATH
ls $OPT_RESULT_DIR | while read line 
do
    TARGET_TRACE=$OPT_TRACE_DIR/$line/GPU_0/$line"*"
    LINE_START=`cat -n $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($1)}'`
    LINE_END=`cat -n $TARGET_TRACE | grep "EXIT" | head -n1 | awk '{print($1)}'`
    SHAPE=`cat $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($3)}'`

    pushd $OPT_RESULT_DIR/$line/
    CYCLE_CNT=`cat GPU_0.out | grep -c "tot_sim_cycle"`
    CYCLE=`cat sim_result.out | grep "NDP kernel" | grep "launched" | awk '{print($11)}'` 
    CYCLE2=`cat sim_result.out | grep "NDP kernel" | grep "finished" | awk '{print($11)}'` 
    JOB_NAME="optimized_kernel${line}"

    RUNNING=`squeue --format "%.200j %u %i" | grep -w $JOB_NAME`
    if [ $CYCLE_CNT -ne 1 ]; then  
        if [ -z "$RUNNING" ]; then
            echo "RUNNING NOT FOUND ${line}" 
            if [ "$RESUBMIT" = "1" ]; then
                rm GPU*
                # run job
                sbatch -J $JOB_NAME -n 1 --partition=allcpu -o sim_result.out -e sim_result.err run.sh;
            fi
        fi
        echo "NOT FOUND $line"
        echo `cat sim_result.out | tail -n1` 
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,"NOT FOUND" >> $OPT_CSV_PATH  ;
    else    
        if [ -n "$RUNNING" ]; then
            echo "POSSIBLE DEADLOCK $line"
        fi
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,$(( CYCLE2 - CYCLE )) >> $OPT_CSV_PATH ;
    fi
    popd
done


echo "NAME,LINES,SHAPE,CYCLE" > $UNOPT_CSV_PATH
ls $UNOPT_RESULT_DIR | while read line 
do
    TARGET_TRACE=$UNOPT_TRACE_DIR/$line/GPU_0/$line"*"
    LINE_START=`cat -n $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($1)}'`
    LINE_END=`cat -n $TARGET_TRACE | grep "EXIT" | head -n1 | awk '{print($1)}'`
    SHAPE=`cat $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($3)}'`

    pushd $UNOPT_RESULT_DIR/$line/
    CYCLE_CNT=`cat GPU_0.out | grep -c "tot_sim_cycle"`
    CYCLE=`cat sim_result.out | grep "NDP kernel" | grep "launched" | awk '{print($11)}'` 
    CYCLE2=`cat sim_result.out | grep "NDP kernel" | grep "finished" | awk '{print($11)}'` 
    JOB_NAME="unoptimized_kernel${line}"

    RUNNING=`squeue --format "%.200j %u %i" | grep -w $JOB_NAME`
    if [ $CYCLE_CNT -ne 1 ]; then  
        if [ -z "$RUNNING" ]; then
            echo "RUNNING NOT FOUND ${line}" 
            if [ "$RESUBMIT" = "1" ]; then
                rm GPU*
                # run job
                sbatch -J $JOB_NAME -n 1 --partition=allcpu -o sim_result.out -e sim_result.err run.sh;
            fi
        fi
        echo "NOT FOUND $line"
        echo `cat sim_result.out | tail -n1` 
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,"NOT FOUND" >> $UNOPT_CSV_PATH  ;
    else    
        if [ -n "$RUNNING" ]; then
            echo "POSSIBLE DEADLOCK $line"
        fi
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,$(( CYCLE2 - CYCLE )) >> $UNOPT_CSV_PATH ;
    fi
    popd
done
