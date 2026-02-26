#!/usr/bin/env bash

# Get script arguments coming from modules/prodigal.nf process
args=("$@")
FASTA_FILE=${args[0]}
LOGCMD=${args[1]}

# Commande to execute
CMD="prodigal -i ${FASTA_FILE} -a ${FASTA_FILE}.faa -d ${FASTA_FILE}.fna -o ${FASTA_FILE}.gff -p meta"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
