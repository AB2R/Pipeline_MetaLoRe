#!/usr/bin/env bash

# Get script arguments coming from modules/samtools_2.nf process
args=("$@")
NCPUS=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD1="samtools sort -@ ${NCPUS} ${FASTQ_FILE} -o ${FASTQ_FILE%%.*}sorted2.bam"

CMD2="samtools index ${FASTQ_FILE%%.*}sorted2.bam"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
