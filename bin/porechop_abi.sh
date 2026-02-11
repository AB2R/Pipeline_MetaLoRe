#!/usr/bin/env bash

# Get script arguments coming from modules/porechopabi.nf process
args=("$@")
NCPUS=${args[0]}
FASTQ_FILE=${args[1]}
LOGCMD=${args[2]}

# Command to execute
CMD="porechop_abi -abi -t ${NCPUS} -i ${FASTQ_FILE} -o trim_${FASTQ_FILE%%.*}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}

