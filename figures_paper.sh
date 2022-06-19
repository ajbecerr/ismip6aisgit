#!/bin/sh
module load gcc
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/util/academic/matlab/R2019b/bin/glnxa64
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/util/academic/matlab/R2019b/runtime/glnxa64
export LD_LIBRARY_PATH
./figures_paper $1