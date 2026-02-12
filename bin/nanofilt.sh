#!/usr/bin/env bash

# Get script arguments coming from modules/nanoplot.nf process
args=("$@")
FASTQ_FILE=${args[0]}
MIN_READ_LENGTH=${args[1]}
QUALITY=${args[2]}
LOGCMD=${args[3]}

# Commande to execute
CMD="cat ${FASTQ_FILE} | NanoFilt -l ${MIN_READ_LENGTH} -q ${QUALITY} > filt_${FASTQ_FILE%%.*}.fastq"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
