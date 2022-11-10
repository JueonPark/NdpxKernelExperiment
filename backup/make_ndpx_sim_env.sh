#!/bin/bash
CONFIG=NDPX_baseline_64
GPUS=1
BUFFERS=1
SIMULATOR_DIR=/home/jueonpark/cxl-simulator
SIMULATOR_BINARY_DIR=$SIMULATOR_DIR/multi_gpu_simulator/gpu-simulator/bin/release
DEVICE_SETTING=GPU_${GPUS}_Buffer_${BUFFERS}
CONFIG_DIR=/home/shared/CXL_memory_buffer/ASPLOS_simulator/cxl-simulator/sim_configs/$DEVICE_SETTING/$CONFIG
OPT_TRACE_DIR=`pwd`/"optimized_kernels"
UNOPT_TRACE_DIR=`pwd`/"/unoptimized_kernels"
RESULT_OPT_DIR=`pwd`"/results/optimized_kernels"
RESULT_UNOPT_DIR=`pwd`"/results/unoptimized_kernels"

#make directories
mkdir -p $RESULT_OPT_DIR
mkdir -p $RESULT_UNOPT_DIR

for OPT_ITEM in `ls $OPT_TRACE_DIR`;
do
    RESULT_DIR=$RESULT_OPT_DIR/$OPT_ITEM
    mkdir -p $RESULT_DIR/output
    echo -e "#!/bin/bash\
            \ncp -r ${SIMULATOR_DIR}/multi_gpu_simulator/gpu-simulator/gpgpu-sim/lib/gcc-7.3.0/cuda-10010/release/ .\
            \ncp ${SIMULATOR_BINARY_DIR}/accel-sim.out .\
            \nexport LD_LIBRARY_PATH=\`pwd\`/release:\$LD_LIBRARY_PATH\
            \n./accel-sim.out -trace ${OPT_TRACE_DIR}/${OPT_ITEM}/ -config ${CONFIG_DIR}/gpgpusim.config -config ${CONFIG_DIR}/trace.config -cxl_config ${CONFIG_DIR}/cxl.config -num_gpus $GPUS -num_cxl_memory_buffers $BUFFERS" > $RESULT_OPT_DIR/$OPT_ITEM/run.sh 
done

for UNOPT_ITEM in `ls $UNOPT_TRACE_DIR`;
do
    RESULT_DIR=$RESULT_UNOPT_DIR/$UNOPT_ITEM
    mkdir -p $RESULT_DIR/output
    echo -e "#!/bin/bash\
            \ncp -r ${SIMULATOR_DIR}/multi_gpu_simulator/gpu-simulator/gpgpu-sim/lib/gcc-7.3.0/cuda-10010/release/ .\
            \ncp ${SIMULATOR_BINARY_DIR}/accel-sim.out .\
            \nexport LD_LIBRARY_PATH=\`pwd\`/release:\$LD_LIBRARY_PATH\
            \n./accel-sim.out -trace ${UNOPT_TRACE_DIR}/${UNOPT_ITEM}/ -config ${CONFIG_DIR}/gpgpusim.config -config ${CONFIG_DIR}/trace.config -cxl_config ${CONFIG_DIR}/cxl.config -num_gpus $GPUS -num_cxl_memory_buffers $BUFFERS" > $RESULT_UNOPT_DIR/$UNOPT_ITEM/run.sh 
done
