#!/usr/bin/env bash

# Get script arguments coming from modules/nanoplot.nf process
args=("$@")
FASTQ_FILE=${args[0]}
NCPUS=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD="NanoPlot -t ${NCPUS} --fastq ${FASTQ_FILE} -o nano_${FASTQ_FILE%%.*}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
