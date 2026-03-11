# Metagenome_Long_Read
Pipeline for microbial flora and atibiotics resistance caracterisation

## Introduction

## Table of contents

### A-Pipeline overview

### B-Compute requirements
Before running the entire pipeline, you need some requirements.

#### PlasmidFinder requirements
Run this command line in your databases repertory :

```
#Clone database from git repository
git clone https://bitbucket.org/genomicepidemiology/plasmidfinder_db.git
cd plasmidfinder_db
#Concatenate all the databases
cat *.fsa > plasmidfinder_all.fasta
```

### C-Data

### D-Tools
#### 1.Quality control
##### 1.1 NanoPlot (v.1.28.4)
NanoPlot is a visualization tool used to assess the quality of long-read sequencing data by generating plots and summary statistics such as read length distributions and quality scores. For this tool we used this biocontainer.

- **Input** : Oxford Nanopore Technology data files (fastq) *ONT_ch*

- **Output** : quality control report (html)

- **Commandline** : 
`NanoPlot -t ${NCPUS} --fastq ${FASTQ_FILE} -o $(basename ${FASTQ_FILE%%.*})_nanoqc`

#### 2. Trimming and Filtering
##### 2.1 Porechop-ABI
Porechop_ABI is a tool used to process adapter sequences in ONT reads.

- **Input** : Oxford Nanopore Technology data files (fastq) *ONT_ch*

- **Output** : Trimmed Oxford Nanopore Technology data files (fastq) *trim_ch*

- **Commandline** :
`porechop_abi -abi -t ${NCPUS} -i ${FASTQ_FILE} -o $(basename ${FASTQ_FILE%%.*})_trim.fastq`

##### 2.2 NanoFilt
NanoFilt is a tool used to filtering reads of long-read sequencing data on quality and/or read length, and optional trimming after passing filters.

- **Input** : Trimmed Oxford Nanopore Technology data files (fastq) *trim_ch*

- **Output** : Filtered Oxford Nanopore Technology data files (fastq) *filt_ch*

- **Commandline** :
`cat ${FASTQ_FILE} | NanoFilt -l ${MIN_READ_LENGTH} -q ${QUALITY} > $(basename ${FASTQ_FILE%%_*})_filt.fastq`

#### 3. Alignment
##### 3.1 Minimap2

- **Input** : Filtered Oxford Nanopore Technology data files (fastq) *filt_ch*

- **Output** : Aligned Oxford Nanopore Technology data files (sam) *aln_ch*

- **Commandline** :
`minimap2 -ax map-ont ${REF} ${FASTQ_FILE} > $(basename ${FASTQ_FILE%%_*})_aln.sam`

##### 3.2 Samtools

- **Input** : Aligned Oxford Nanopore Technology data files (sam) *aln_ch*

- **Output** : Sorted of unmaped Oxford Nanopore Technology data files (bam) *sorted_ch*

- **Commandline** :
`samtools view -bS -@ ${NCPUS} -f 4 ${FASTQ_FILE} > $(basename ${FASTQ_FILE%%_*})_unmaped.bam`
`samtools sort -@ ${NCPUS} -n $(basename ${FASTQ_FILE%%_*})_unmaped.bam -o $(basename ${FASTQ_FILE%%_*})_sorted.bam`

##### 3.3 Bedtools

- **Input** : Sorted of unmaped Oxford Nanopore Technology data files (bam) *sorted_ch*

- **Output** : Fitted Oxford Nanopore Technology data files (fastq) *fitted_ch*

- **Commandline** :
`bedtools bamtofastq -i ${FASTQ_FILE} -fq $(basename ${FASTQ_FILE%%_*})_fitted.fastq`

