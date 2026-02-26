#!/usr/bin/env bash

# Get script arguments coming from modules/quast.nf process
args=("$@")
ASSEMBLY_FILE=${args[0]}
RACON_FILE=${args[1]}
MEDAKA_FILE=${args[2]}
NCPUS=${args[3]}
OUT_DIR=${args[4]}
LOGCMD=${args[5]}

# Commande to execute
CMD="quast ${ASSEMBLY_FILE} ${RACON_FILE} ${MEDAKA_FILE} --threads ${NCPUS} -o ${OUT_DIR}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
