#!/usr/bin/env bash

# Get script arguments coming from modules/minimap2_1.nf process
args=("$@")
REF=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD="minimap2 -ax map-ont ${REF} ${FASTQ_FILE} > $(basename ${FASTQ_FILE%%_*})_aln1.sam"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
