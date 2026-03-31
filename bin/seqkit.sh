#!/usr/bin/env bash

# Get script arguments coming from modules/seqkit.nf process
args=("$@")
ID_FILE=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD1="seqkit grep -f ${ID_FILE} ${FASTQ_FILE} -o $(basename ${FASTQ_FILE%%_*})_filtid.fastq"
CMD2="seqkit fq2fa $(basename ${FASTQ_FILE%%_*})_filtid.fastq > $(basename ${FASTQ_FILE%%_*})_filtid.fasta"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
