#!/usr/bin/env bash

# Get script arguments coming from modules/racon_2.nf process
args=("$@")
FASTQ_FILE=${args[0]}
SAM=${args[1]}
FASTA_FILE=${args[2]}
NCPUS=${args[3]}
LOGCMD=${args[4]}

# Commande to execute
CMD="racon ${FASTQ_FILE} ${SAM} ${FASTA_FILE} -t ${NCPUS} > racon2.fasta"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
