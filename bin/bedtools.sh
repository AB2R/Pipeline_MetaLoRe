#!/usr/bin/env bash

# Get script arguments coming from modules/bedtools.nf process
args=("$@")
FASTQ_FILE=${args[0]}
LOGCMD=${args[1]}

# Commande to execute
CMD="bedtools bamtofastq -i ${FASTQ_FILE} -fq ${FASTQ_FILE%%_*}_fitted.fastq"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
