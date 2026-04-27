#!/usr/bin/env bash

# Get script arguments coming from modules/gtdbtk.nf process
args=("$@")
FASTA_GZ_FILE=${args[0]}
OUT_DIR=${args[1]}
NCPUS=${args[2]}
LOGCMD=${args[3]}
FASTA_FILE=$(basename ${FASTA_GZ_FILE} .gz)
BINS_DIR="Bins"
BASENAME=$(basename ${FASTA_FILE} .fa)

# Commande to execute
CMD1="mkdir -p ${BINS_DIR}"
CMD2="gunzip -c ${FASTA_GZ_FILE} > ${BINS_DIR}/${FASTA_FILE}"
CMD3="gtdbtk classify_wf --genome_dir Bins/ --out_dir ${OUT_DIR}/${BASENAME} --cpus ${NCPUS} --extension fa"

# Save command in log
echo ${CMD1} >> ${LOGCMD}
echo ${CMD2} >> ${LOGCMD}
echo ${CMD3} >> ${LOGCMD}
# Execute command
eval ${CMD1}
eval ${CMD2}
eval ${CMD3}
