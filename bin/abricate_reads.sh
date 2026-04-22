#!/usr/bin/env bash

# Get script arguments coming from modules/abricate_reads.nf process
args=("$@")
FASTA_FILE=${args[0]}
DB2=${args[1]}
DB3=${args[2]}
DB4=${args[3]}
DB5=${args[4]}
LOGCMD=${args[5]}
BASENAME=$(basename ${FASTA_FILE} .fna)

# Commande to execute
CMD1="abricate ${FASTA_FILE} > ${BASENAME}_results_ncbi.tab"
CMD2="abricate --db ${DB2} ${FASTA_FILE} > ${BASENAME}_results_${DB2}.tab"
CMD3="abricate --db ${DB3} ${FASTA_FILE} > ${BASENAME}_results_${DB3}.tab"
CMD4="abricate --db ${DB4} ${FASTA_FILE} > ${BASENAME}_results_${DB4}.tab"
CMD5="abricate --db ${DB5} ${FASTA_FILE} > ${BASENAME}_results_${DB5}.tab"
CMD6="abricate --summary *results_ncbi.tab *results_${DB2}.tab *results_${DB3}.tab *results_${DB4}.tab *results_${DB5}.tab"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}
echo ${CMD3} >> ${LOGCMD}
echo ${CMD4} >> ${LOGCMD}
echo ${CMD5} >> ${LOGCMD}
echo ${CMD6} >> ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
eval ${CMD3}
eval ${CMD4}
eval ${CMD5}
eval ${CMD6}
