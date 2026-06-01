#!/usr/bin/env bash

# Get script arguments coming from modules/blast_mobileog.nf process
args=("$@")
FASTA_FILE=${args[0]}
DB_MOBILEOG=${args[1]}
NCPUS=${args[2]}
LOGCMD=${args[3]}
OUT_NAME=$(basename ${FASTA_FILE} .faa)_blast_mobileog.tab

# Commande to execute
blastp \
    -query ${FASTA_FILE} \
    -db ${DB_MOBILEOG} \
    -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore slen" \
    -num_threads ${NCPUS} | \
awk -F'\t' 'BEGIN{OFS="\t"} {print $0, ($4-$5)/$13*100}' > ${OUT_NAME}

