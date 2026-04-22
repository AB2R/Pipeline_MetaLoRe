#!/usr/bin/env bash

# Get script arguments coming from modules/multiqc.nf process
args=("$@")
RESULTS_REPOSITORY=${args[0]}
LOGCMD=${args[1]}

# Commande to execute
CMD="multiqc ${RESULTS_REPOSITORY}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
