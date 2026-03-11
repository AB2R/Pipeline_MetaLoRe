#!/usr/bin/env bash

# Get script arguments coming from modules/blast_plasmidfinder.nf process
args=("$@")
FASTA_GZ_FILE=${args[0]}
DB_PLASMIDFINDER=${args[1]}
LOGCMD=${args[2]}
FASTA_FILE=$(basename ${FASTA_GZ_FILE} .gz)
OUT_NAME=$(basename ${FASTA_FILE} .fa).tab

# Commande to execute
CMD1="gunzip -c ${FASTA_GZ_FILE} > ${FASTA_FILE}"
CMD2="blastn -query ${FASTA_FILE} -db ${DB_PLASMIDFINDER} -out ${OUT_NAME} -outfmt 6"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
