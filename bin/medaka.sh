#!/usr/bin/env bash

# Get script arguments coming from modules/medaka.nf process
args=("$@")
FASTQ_FILE=${args[0]}
FASTA_FILE=${args[1]}
NCPUS=${args[2]}
OUTDIR=${args[3]}
MODELE=${args[4]}
LOGCMD=${args[5]}

# Commande to execute
CMD="medaka_consensus -i ${FASTQ_FILE} -d ${FASTA_FILE} -t ${NCPUS} -o ${OUTDIR} -m ${MODELE}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
