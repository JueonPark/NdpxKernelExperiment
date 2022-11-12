#!/bin/bash
MODEL=$1
RESUBMIT=1

SIMULATOR_DIR=/home/jueonpark/cxl-simulator
SIMULATOR_BINARY_DIR=$SIMULATOR_DIR/multi_gpu_simulator/gpu-simulator/bin/release

NOOPT_TRACE_DIR=`pwd`/"traces/$MODEL/noopt"
MEMORY_TRACE_DIR=`pwd`/"traces/$MODEL/memory"
NUMBERING_TRACE_DIR=`pwd`/"traces/$MODEL/numbering"
ALLOPT_TRACE_DIR=`pwd`/"traces/$MODEL/allopt"

NOOPT_RESULT_DIR=`pwd`"/results/$MODEL/noopt"
MEMORY_RESULT_DIR=`pwd`"/results/$MODEL/memory"
NUMBERING_RESULT_DIR=`pwd`"/results/$MODEL/numbering"
ALLOPT_RESULT_DIR=`pwd`"/results/$MODEL/allopt"

CSV_FILES=`pwd`/csv_files
NOOPT_CSV_PATH=$CSV_FILES/$MODEL-noopt.csv
MEMORY_CSV_PATH=$CSV_FILES/$MODEL-memory.csv
NUMBERING_CSV_PATH=$CSV_FILES/$MODEL-numbering.csv
ALLOPT_CSV_PATH=$CSV_FILES/$MODEL-allopt.csv

echo "NAME,LINES,SHAPE,CYCLE" > $NOOPT_CSV_PATH
ls $NOOPT_RESULT_DIR | while read line 
do
    TARGET_TRACE=$NOOPT_TRACE_DIR/$line/GPU_0/$line"*"
    LINE_START=`cat -n $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($1)}'`
    LINE_END=`cat -n $TARGET_TRACE | grep "EXIT" | head -n1 | awk '{print($1)}'`
    SHAPE=`cat $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($3)}'`

    pushd $NOOPT_RESULT_DIR/$line/
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
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,"NOT FOUND" >> $NOOPT_CSV_PATH  ;
    else    
        if [ -n "$RUNNING" ]; then
            echo "POSSIBLE DEADLOCK $line"
        fi
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,$(( CYCLE2 - CYCLE )) >> $NOOPT_CSV_PATH ;
    fi
    popd
done

echo "NAME,LINES,SHAPE,CYCLE" > $MEMORY_CSV_PATH
ls $MEMORY_RESULT_DIR | while read line 
do
    TARGET_TRACE=$UNOPT_TRACE_DIR/$line/GPU_0/$line"*"
    LINE_START=`cat -n $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($1)}'`
    LINE_END=`cat -n $TARGET_TRACE | grep "EXIT" | head -n1 | awk '{print($1)}'`
    SHAPE=`cat $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($3)}'`

    pushd $MEMORY_RESULT_DIR/$line/
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
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,"NOT FOUND" >> $MEMORY_CSV_PATH  ;
    else    
        if [ -n "$RUNNING" ]; then
            echo "POSSIBLE DEADLOCK $line"
        fi
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,$(( CYCLE2 - CYCLE )) >> $MEMORY_CSV_PATH ;
    fi
    popd
done

echo "NAME,LINES,SHAPE,CYCLE" > $NUMBERING_CSV_PATH
ls $NUMBERING_RESULT_DIR | while read line 
do
    TARGET_TRACE=$UNOPT_TRACE_DIR/$line/GPU_0/$line"*"
    LINE_START=`cat -n $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($1)}'`
    LINE_END=`cat -n $TARGET_TRACE | grep "EXIT" | head -n1 | awk '{print($1)}'`
    SHAPE=`cat $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($3)}'`

    pushd $NUMBERING_RESULT_DIR/$line/
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
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,"NOT FOUND" >> $NUMBERING_CSV_PATH  ;
    else    
        if [ -n "$RUNNING" ]; then
            echo "POSSIBLE DEADLOCK $line"
        fi
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,$(( CYCLE2 - CYCLE )) >> $NUMBERING_CSV_PATH ;
    fi
    popd
done

echo "NAME,LINES,SHAPE,CYCLE" > $ALLOPT_CSV_PATH
ls $ALLOPT_RESULT_DIR | while read line 
do
    TARGET_TRACE=$UNOPT_TRACE_DIR/$line/GPU_0/$line"*"
    LINE_START=`cat -n $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($1)}'`
    LINE_END=`cat -n $TARGET_TRACE | grep "EXIT" | head -n1 | awk '{print($1)}'`
    SHAPE=`cat $TARGET_TRACE | grep "SET_FILTER" | head -n1 | awk '{print($3)}'`

    pushd $ALLOPT_RESULT_DIR/$line/
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
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,"NOT FOUND" >> $ALLOPT_CSV_PATH  ;
    else    
        if [ -n "$RUNNING" ]; then
            echo "POSSIBLE DEADLOCK $line"
        fi
        echo $line,$(( LINE_END - LINE_START )),$SHAPE,$(( CYCLE2 - CYCLE )) >> $ALLOPT_CSV_PATH ;
    fi
    popd
done
