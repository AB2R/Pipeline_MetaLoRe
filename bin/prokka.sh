#!/usr/bin/env bash

# Get script arguments coming from modules/prokka.nf process
args=("$@")
OUT_DIR=${args[0]}
FASTA_GZ_FILE=${args[1]}
LOGCMD=${args[2]}
FASTA_FILE=$(basename ${FASTA_GZ_FILE} .gz)
BASENAME=$(basename ${FASTA_FILE} .fa)

# Commande to execute
CMD1="gunzip -c ${FASTA_GZ_FILE} > ${FASTA_FILE}"
CMD2="prokka --metagenome --outdir ${OUT_DIR}/${BASENAME} ${FASTA_FILE}"

# Save command in log
echo ${CMD1} > ${LOGCMD}
echo ${CMD2} > ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
