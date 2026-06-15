#!/usr/bin/env bash

# Get script arguments coming from modules/samtools_1.nf process
args=("$@")
NCPUS=${args[0]}
SAM_FILE=${args[1]}
LOGCMD=${args[2]}

BAM=${SAM_FILE%%_*}.bam
SORTED_BAM=${SAM_FILE%%_*}_sorted.bam

# Commande to execute
samtools view -bS -@ ${NCPUS} ${SAM_FILE} > ${BAM}

samtools sort -@ ${NCPUS} ${BAM} -o ${SORTED_BAM}

samtools index ${SORTED_BAM}

samtools view -H ${SORTED_BAM} \
| awk '/^@SQ/ {
    for(i=1;i<=NF;i++){
        if($i ~ /^SN:/) sn=substr($i,4);
        if($i ~ /^LN:/) ln=substr($i,4);
    }
    print sn "\t" ln
}' > lengths.txt

samtools depth -a ${SORTED_BAM} \
| awk 'NR==FNR {len[$1]=$2; next}
       {sum[$1]+=$3}
END {
    for (c in sum)
        print c "\t" len[c] "\t" sum[c]
}' lengths.txt - > cov.txt

awk '
{
    cov = $3 / $2
    total += cov

    gene[NR] = $1
    len[NR]  = $2
    bases[NR] = $3
    covg[NR] = cov
}
END {
    for(i=1;i<=NR;i++){
        gcpm = (covg[i] / total) * 1000000
        print gene[i] "\t" len[i] "\t" bases[i] "\t" gcpm
    }
}' cov.txt > gcpm.txt
