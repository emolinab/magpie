#!/bin/bash

#SBATCH --qos=medium
#SBATCH --job-name=mag-run
#SBATCH --output=slurm.log
#SBATCH --mail-type=END
#SBATCH --cpus-per-task=3
#SBATCH --partition=standard
#SBATCH --mem=32000

Rscript submit.R
