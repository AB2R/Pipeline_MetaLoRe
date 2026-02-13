#!/usr/bin/env bash

# Get script arguments coming from modules/minimap2.nf process
args=("$@")
REF=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD="minimap2 -ax map-ont ${REF} ${FASTQ_FILE} > aln_${FASTQ_FILE%}.sam"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
