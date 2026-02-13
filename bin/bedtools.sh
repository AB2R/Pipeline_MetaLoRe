#!/usr/bin/env bash

# Get script arguments coming from modules/bedtools.nf process
args=("$@")
FASTQ_FILE=${args[0]}
LOGCMD=${args[1]}

# Commande to execute
CMD="bedtools bamtofastq -i ${FASTQ_FILE} -fq fitted_${FASTQ_FILE%%.*}.fastq"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
