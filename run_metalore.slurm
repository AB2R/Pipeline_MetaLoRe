#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=24:00:00

# 1 - Set directory for nextflow environment
. /local/env/envnextflow-23.10.0.sh

# 2 - Set working directory
WK_DIR=/scratch/cpoisson/PROJET_ANSES_2026_scratch/MetaLoRe

if [ ! -e "$WK_DIR" ]; then
  echo "ERROR: $WK_DIR does not exist" >&2
  exit 1
fi

# 3 - Set directory containing working data sets (sequencing raw data) 
export DATA_PATH=/scratch/cpoisson/PROJET_ANSES_2026_scratch/MetaLoRe/data
if [ ! -e "$DATA_PATH" ]; then
  echo "ERROR: $DATA_PATH does not exist" >&2
  exit 1
fi

# 4  - Set directory containing singularity images 
export NXF_SINGULARITY_CACHEDIR=$WK_DIR/containers
export NXF_TEMP=$WK_DIR/.nxf_temp_metalore
mkdir -p $NXF_TEMP

export SCRATCH=$WK_DIR/scratch
mkdir -p $SCRATCH

# 5 - Run pipeline
nextflow run main.nf -profile genouest,custom,singularity -c genouest.config -resume &> metalore.log 2>&1
