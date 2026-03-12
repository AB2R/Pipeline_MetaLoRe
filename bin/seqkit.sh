#!/usr/bin/env bash

# Get script arguments coming from modules/seqkit.nf process
args=("$@")
ID_FILE=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD="seqkit grep -f ${ID_FILE} ${FASTQ_FILE} -o $(basename ${FASTQ_FILE%%_*})_filtid.fastq"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
