#!/usr/bin/env bash

# Get script arguments coming from modules/blast_reads_plasmidfinder.nf process
args=("$@")
FASTA_FILE=${args[0]}
DB_PLASMIDFINDER=${args[1]}
LOGCMD=${args[2]}
OUT_NAME=$(basename ${FASTA_FILE} .fna).tab

# Commande to execute
CMD="blastn -query ${FASTA_FILE} -db ${DB_PLASMIDFINDER} -out ${OUT_NAME} -outfmt 6"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}

