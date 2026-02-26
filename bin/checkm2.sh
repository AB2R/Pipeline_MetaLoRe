#!/usr/bin/env bash

# Get script arguments coming from modules/checkm2.nf process
args=("$@")
FASTA_FILE=${args[0]}
OUT_DIR=${args[1]}
NCPUS=${args[2]}
DB_PATH=${args[3]}
LOGCMD=${args[4]}

# Commande to execute
CMD="checkm2 predict -i ${FASTA_FILE} -o ${OUT_DIR} -t ${NCPUS} -x fa.gz --database_path ${DB_PATH}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
