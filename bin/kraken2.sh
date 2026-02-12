#!/usr/bin/env bash

# Get script arguments coming from modules/kraken2.nf process
args=("$@")
NCPUS=${args[0]}
DB_KRAKEN=${args[1]}
FASTQ_FILE=${args[2]}
LOGCMD=${args[3]}

# Commande to execute
CMD="kraken2 --threads ${NCPUS} --db ${DB_KRAKEN} --report ${FASTQ_FILE%%.*}.report --output ${FASTQ_FILE%%.*}.kraken --use-names ${FASTQ_FILE}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
