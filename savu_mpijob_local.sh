#!/bin/bash

echo "SAVU_MPI_LOCAL:: Running Job"

nNodes=1
nCoresPerNode=`lscpu --all --parse=CORE,SOCKET | grep -E "^[0-9]" | wc -l`
nGPUs=$(nvidia-smi -L | wc -l)

echo "***********************************************"
echo -e "\tRunning on $nCoresPerNode CPUs and $nGPUs GPUs"
echo "***********************************************"

datafile=$1
processfile=$2
outpath=$3
shift 3
options=$@

savupath=/dls/science/users/twj43146/programming/savu-example
filename=$savupath/tomo_recon.py
#savupath=$(python -c "import savu, os; print (savu.__path__[0])"):$savupath
#savupath=/dls_sw/apps/savu/4.2_release/Savu_v4.2/miniconda/lib/python3.7/site-packages/savu-4.2-py3.7.egg/savu
#savupath=$savupath/savu
echo "savupath is:" $savupath

nCPUs=$((nNodes*nCoresPerNode))

# launch mpi job

echo "running on host: "$HOSTNAME
echo "Processes running are : ${nCPUs}"

processes=`bc <<< "$nCPUs"`

for i in $(seq 0 $((nGPUs-1))); do GPUs+="GPU$i " ; done
for i in $(seq 0 $((nCPUs-1-nGPUs))); do CPUs+="CPU$i " ; done
CPUs=$(echo $GPUs$CPUs | tr ' ' ,)

echo "running the savu mpi local job"
mpiexec -np $nCPUs -mca btl ^openib tau_python $filename $datafile $processfile $outpath -n $CPUs -v $options --profile io+field+2

echo "SAVU_MPI_LOCAL:: Process complete"
