#!/usr/bin/env bash

# Get script arguments coming from modules/flye.nf process
args=("$@")
FASTQ_FILE=${args[0]}
OUT_DIR=${args[1]}
NCPUS=${args[2]}
LOGCMD=${args[3]}

# Commande to execute
CMD="flye --nano-raw ${FASTQ_FILE} --out-dir ${OUT_DIR} --threads ${NCPUS} --meta"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
