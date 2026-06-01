#!/usr/bin/env bash

# Get script arguments coming from modules/prodigal_reads.nf process
args=("$@")
FASTA_FILE=${args[0]}
LOGCMD=${args[1]}

# Commande to execute
CMD="prodigal -i ${FASTA_FILE} -a $(basename ${FASTA_FILE%%_*}).faa -d $(basename ${FASTA_FILE%%_*}).fna -o $(basename ${FASTA_FILE%%_*}).gbk -p meta"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
