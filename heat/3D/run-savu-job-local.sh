#!/bin/bash

#$ -l h_rt=00:30:0
#$ -N HEAT
#$ -pe openmpi 40
#$ -l gpus=4
#$ -P p45
#$ -l m_mem_free=6G


module purge
module load python/3.7
module load savu/4.2-release
module load openmpi/4.1.1
module load tau/2.31/openmpi-4.1__python-3.7
## module load tau/2.31/mybuild
conda activate /dls/science/users/twj43146/conda/envs/tau

dir=/dls/science/users/twj43146/programming/heat/3D

## export TAU_EBS_PERIOD=1000
export TAU_METRICS=TIME
export TAU_COMM_MATRIX=1
export TAU_CALLPATH=1
#export TAU_CALLPATH_DEPTH=100
export TAU_SAMPLING=1

mpirun -np 6  tau_exec $dir/a.out 100 10
