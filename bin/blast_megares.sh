#!/usr/bin/env bash

# Get script arguments coming from modules/blast_megares.nf process
args=("$@")
FASTA_FILE=${args[0]}
DB_MEGARES=${args[1]}
LOGCMD=${args[2]}
OUT_NAME=$(basename ${FASTA_FILE} .fna)_blast_megares.tab

# Commande to execute
blastn \
    -query ${FASTA_FILE} \
    -db ${DB_MEGARES} \
    -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore slen" | \
awk -F'\t' 'BEGIN{OFS="\t"} {print $0, ($4-$5)/$13*100}' > ${OUT_NAME}

