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


- **Input** : Oxford Nanopore Technology data files (fastq) 

- **Output** : quality control report (html)

- **Commandline** : 
`NanoPlot -t ${NCPUS} --fastq ${FASTQ_FILE} -o nano_${FASTQ_FILE%%.*}`

#### 2. Trimming and Filtering
##### 2.1 Porechop-ABI

- **Input** :

- **Output** :

- **Commandline** :

##### 2.2 NanoFilt

- **Input** :

- **Output** :

- **Commandline** :

#### 3. Alignment
##### 3.1 Minimap2

- **Input** :

- **Output** :

- **Commandline** :

##### 3.2 Samtools

- **Input** :

- **Output** :

- **Commandline** :

##### 3.3 Bedtools

- **Input** :

- **Output** :

- **Commandline** :

