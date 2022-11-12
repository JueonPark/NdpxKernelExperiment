#!/bin/bash
CONFIG=NDPX_baseline_64
MODEL=$1
GPUS=1
BUFFERS=1
SIMULATOR_DIR=/home/jueonpark/cxl-simulator
SIMULATOR_BINARY_DIR=$SIMULATOR_DIR/multi_gpu_simulator/gpu-simulator/bin/release
DEVICE_SETTING=GPU_${GPUS}_Buffer_${BUFFERS}
CONFIG_DIR=/home/shared/CXL_memory_buffer/ASPLOS_simulator/cxl-simulator/sim_configs/$DEVICE_SETTING/$CONFIG

NOOPT_TRACE_DIR=`pwd`/"traces/$MODEL/noopt"
MEMORY_TRACE_DIR=`pwd`/"traces/$MODEL/memory"
NUMBERING_TRACE_DIR=`pwd`/"traces/$MODEL/numbering"
ALLOPT_TRACE_DIR=`pwd`/"traces/$MODEL/allopt"

NOOPT_RESULT_DIR=`pwd`"/results/$MODEL/noopt"
MEMORY_RESULT_DIR=`pwd`"/results/$MODEL/memory"
NUMBERING_RESULT_DIR=`pwd`"/results/$MODEL/numbering"
ALLOPT_RESULT_DIR=`pwd`"/results/$MODEL/allopt"

#make directories
mkdir -p $NOOPT_RESULT_DIR
mkdir -p $MEMORY_RESULT_DIR
mkdir -p $NUMBERING_RESULT_DIR
mkdir -p $ALLOPT_RESULT_DIR

for item in `ls $NOOPT_TRACE_DIR`; do
  RESULT_DIR=$NOOPT_RESULT_DIR/$item
  mkdir -p $RESULT_DIR/output
  echo -e "#!/bin/bash\
          \ncp -r ${SIMULATOR_DIR}/multi_gpu_simulator/gpu-simulator/gpgpu-sim/lib/gcc-7.3.0/cuda-10010/release/ .\
          \ncp ${SIMULATOR_BINARY_DIR}/accel-sim.out .\
          \nexport LD_LIBRARY_PATH=\`pwd\`/release:\$LD_LIBRARY_PATH\
          \n./accel-sim.out -trace $NOOPT_TRACE_DIR/${item}/ -config ${CONFIG_DIR}/gpgpusim.config -config ${CONFIG_DIR}/trace.config -cxl_config ${CONFIG_DIR}/cxl.config -num_gpus $GPUS -num_cxl_memory_buffers $BUFFERS" > $RESULT_DIR/run.sh 
done

for item in `ls $MEMORY_TRACE_DIR`; do
  RESULT_DIR=$MEMORY_RESULT_DIR/$item
  mkdir -p $RESULT_DIR/output
  echo -e "#!/bin/bash\
          \ncp -r ${SIMULATOR_DIR}/multi_gpu_simulator/gpu-simulator/gpgpu-sim/lib/gcc-7.3.0/cuda-10010/release/ .\
          \ncp ${SIMULATOR_BINARY_DIR}/accel-sim.out .\
          \nexport LD_LIBRARY_PATH=\`pwd\`/release:\$LD_LIBRARY_PATH\
          \n./accel-sim.out -trace $MEMORY_TRACE_DIR/${item}/ -config ${CONFIG_DIR}/gpgpusim.config -config ${CONFIG_DIR}/trace.config -cxl_config ${CONFIG_DIR}/cxl.config -num_gpus $GPUS -num_cxl_memory_buffers $BUFFERS" > $RESULT_DIR/run.sh 
done

for item in `ls $NUMBERING_TRACE_DIR`; do
  RESULT_DIR=$NUMBERING_RESULT_DIR/$item
  mkdir -p $RESULT_DIR/output
  echo -e "#!/bin/bash\
          \ncp -r ${SIMULATOR_DIR}/multi_gpu_simulator/gpu-simulator/gpgpu-sim/lib/gcc-7.3.0/cuda-10010/release/ .\
          \ncp ${SIMULATOR_BINARY_DIR}/accel-sim.out .\
          \nexport LD_LIBRARY_PATH=\`pwd\`/release:\$LD_LIBRARY_PATH\
          \n./accel-sim.out -trace $NUMBERING_TRACE_DIR/${item}/ -config ${CONFIG_DIR}/gpgpusim.config -config ${CONFIG_DIR}/trace.config -cxl_config ${CONFIG_DIR}/cxl.config -num_gpus $GPUS -num_cxl_memory_buffers $BUFFERS" > $RESULT_DIR/run.sh 
done

for item in `ls $ALLOPT_TRACE_DIR`; do
  RESULT_DIR=$ALLOPT_RESULT_DIR/$item
  mkdir -p $RESULT_DIR/output
  echo -e "#!/bin/bash\
          \ncp -r ${SIMULATOR_DIR}/multi_gpu_simulator/gpu-simulator/gpgpu-sim/lib/gcc-7.3.0/cuda-10010/release/ .\
          \ncp ${SIMULATOR_BINARY_DIR}/accel-sim.out .\
          \nexport LD_LIBRARY_PATH=\`pwd\`/release:\$LD_LIBRARY_PATH\
          \n./accel-sim.out -trace $ALLOPT_TRACE_DIR/${item}/ -config ${CONFIG_DIR}/gpgpusim.config -config ${CONFIG_DIR}/trace.config -cxl_config ${CONFIG_DIR}/cxl.config -num_gpus $GPUS -num_cxl_memory_buffers $BUFFERS" > $RESULT_DIR/run.sh 
done