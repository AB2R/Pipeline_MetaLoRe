#!/usr/bin/env bash

# Get script arguments coming from modules/blast_db_plasmidfinder.nf process
args=("$@")
DB_PATH=${args[0]}
DB_TYPE=${args[1]}
LOGCMD=${args[2]}
OUT_NAME="plasmidfinder_all_db"

# Commande to execute
CMD="makeblastdb -in ${DB_PATH} -dbtype ${DB_TYPE} -out ${OUT_NAME}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
