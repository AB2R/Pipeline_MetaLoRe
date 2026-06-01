#!/usr/bin/env bash

# Get script arguments coming from modules/kraken2_asmbl.nf process
args=("$@")
NCPUS=${args[0]}
DB_KRAKEN=${args[1]}
FASTA_FILE=${args[2]}
LOGCMD=${args[3]}

# Commande to execute
CMD="kraken2 --threads ${NCPUS} --db ${DB_KRAKEN} --report $(basename ${FASTA_FILE%%_*}).report --output $(basename ${FASTA_FILE%%_*}).kraken --use-names ${FASTA_FILE}"

# Save command in log
echo ${CMD} > ${LOGCMD}

# Execute command
eval ${CMD}
