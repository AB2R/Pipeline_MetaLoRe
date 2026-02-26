#!/usr/bin/env bash

# Get script arguments coming from modules/semibin.nf process
args=("$@")
FASTA_FILE=${args[0]}
BAM=${args[1]}
OUT_DIR=${args[2]}
NCPUS=${args[3]}
ENV=${args[4]}
LOGCMD=${args[5]}

# Commande to execute
CMD="SemiBin2 single_easy_bin -i  ${FASTA_FILE} -b ${BAM} -o ${OUT_DIR} --threads ${NCPUS} --environment ${ENV}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
