#!/usr/bin/env bash

# Get script arguments coming from modules/samtools.nf process
args=("$@")
NCPUS=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Commande to execute
CMD1="samtools view -bS -@ ${NCPUS} -f 4 ${FASTQ_FILE} > unmaped_${FASTQ_FILE}.bam "

CMD2="samtools sort -@ ${NCPUS} -n unmaped_${FASTQ_FILE}.bam -o sorted_unmaped_${FASTQ_FILE}.bam"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}

# Execute command
eval ${CMD1}
eval ${CMD2}
