#!/usr/bin/env bash

# Get script arguments coming from modules/blast_reads_mobileOG.nf process
args=("$@")
FASTA_FILE=${args[0]}
DB_MOBILEOG=${args[1]}
NCPUS=${args[2]}
LOGCMD=${args[3]}
OUT_NAME=$(basename ${FASTA_FILE} .faa).tab

# Commande to execute
CMD="blastp -query ${FASTA_FILE} -db ${DB_MOBILEOG} -out ${OUT_NAME} -num_threads ${NCPUS} -outfmt 6"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}

