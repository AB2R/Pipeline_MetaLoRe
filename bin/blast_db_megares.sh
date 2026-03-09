#!/usr/bin/env bash

# Get script arguments coming from modules/blast_db_megares.nf process
args=("$@")
DB_PATH=${args[0]}
DB_TYPE=${args[1]}
LOGCMD=${args[2]}
OUT_NAME="megares_database_v3"

# Commande to execute
CMD="makeblastdb -in ${DB_PATH} -dbtype ${DB_TYPE} -out ${OUT_NAME}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
