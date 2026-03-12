#!/usr/bin/env bash

# Get script arguments coming from modules/samtools.nf process
args=("$@")
NCPUS=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD1="samtools view -bS -@ ${NCPUS} -f 4 ${FASTQ_FILE} > ${FASTQ_FILE%%_*}_unmaped.bam "

CMD2="samtools sort -@ ${NCPUS} -n ${FASTQ_FILE%%_*}_unmaped.bam -o ${FASTQ_FILE%%_*}_sorted.bam"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
