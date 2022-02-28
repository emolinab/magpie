#!/bin/bash

#SBATCH --qos=medium
#SBATCH --ntasks=1
#SBATCH --job-name=mag-run
#SBATCH --output=slurm.log
#SBATCH --mail-type=END
#SBATCH --cpus-per-task=16
#SBATCH --partition=standard


Rscript submit.R
