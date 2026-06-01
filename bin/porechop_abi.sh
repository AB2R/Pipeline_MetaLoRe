#!/usr/bin/env bash

# Get script arguments coming from modules/porechopabi.nf process
args=("$@")
NCPUS=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Command to execute
CMD="porechop_abi -abi -t ${NCPUS} -i ${FASTQ_FILE} -o $(basename ${FASTQ_FILE%%_*})_trim.fastq"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}

