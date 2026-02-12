#!/usr/bin/env bash

# Get script arguments coming from modules/nanoplot.nf process
args=("$@")
FASTQ_FILE=${args[0]}
LOGCMD=${args[1]}

OUT_FASTQ=fitted_${FASTQ_FILE%%.*}.fastq

# Commande to execute
CMD="bedtools bamtofastq -i ${FASTQ_FILE} -fq ${OUT_FASTQ}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
