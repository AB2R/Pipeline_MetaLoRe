#!/usr/bin/env bash

# Get script arguments coming from modules/minimap2_4.nf process
args=("$@")
ASSEMBLY_FASTA=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD="minimap2 -ax map-ont ${ASSEMBLY_FASTA} ${FASTQ_FILE} > ${FASTQ_FILE%%.*}_aln4.sam"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
