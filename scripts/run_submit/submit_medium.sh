#!/bin/bash

#SBATCH --qos=medium
#SBATCH --job-name=mag-run
#SBATCH --output=slurm.log
#SBATCH --mail-type=END
#SBATCH --mem-per-cpu=0
#SBATCH --cpus-per-task=16
#SBATCH --partition=standard


Rscript submit.R
