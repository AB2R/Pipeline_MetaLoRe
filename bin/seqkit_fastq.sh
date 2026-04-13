#!/usr/bin/env bash

# Get script arguments coming from modules/seqkit.nf process
args=("$@")
FASTQ_FILE=${args[0]}
LOGCMD=${args[1]}

# Commande to execute
CMD="seqkit replace -p '\s.*' -r '' ${FASTQ_FILE} > $(basename ${FASTQ_FILE%%_*})_clean.fastq"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
