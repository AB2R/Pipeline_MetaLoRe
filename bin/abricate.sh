#!/usr/bin/env bash

# Get script arguments coming from modules/abricate.nf process
args=("$@")
FASTA_FILE=${args[0]}
DB2=${args[1]}
DB3=${args[2]}
LOGCMD=${args[3]}
BASENAME=$(basename ${FASTA_FILE%%_*} .fna)

# Commande to execute
CMD1="abricate ${FASTA_FILE} --minid 80 --mincov 60 > ${BASENAME}_abr_ncbi.tab"
CMD2="abricate --minid 80 --mincov 60 --db ${DB2} ${FASTA_FILE} > ${BASENAME}_abr_${DB2}.tab"
CMD3="abricate --minid 80 --mincov 60 --db ${DB3} ${FASTA_FILE} > ${BASENAME}_abr_${DB3}.tab"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}
echo ${CMD3} >> ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
eval ${CMD3}
