# Metagenome_Long_Read
Pipeline for microbial flora and atibiotics resistance caracterisation

## Introduction

## Table of contents

## A-Pipeline overview
![Pipeline](images/Pipeline_MetaLoRe.png)

## B-Compute requirements
Before running the entire pipeline, you need some requirements.

### CheckM2 requirements
Download the database for CheckM2 using this link :
[CheckM2 database](https://zenodo.org/record/14897628)

Create a repertory on the cluster :  
 
`mkdir databases/CheckM2_database`

Load the database on the cluster with this command line :  

`scp path/of/the/database/on/your/computer username@genossh.genouest.org:/path/on/the/cluster`

Extract the database :
```
cd databases/CheckM2_database
gunzip database_name
```

### Megares 
Download the database Megares (All sequences) using this link :
[Megares database](https://www.meglab.org/megares/download/)

Create a repertory on the cluster :  

`mkdir databases/Megares_database`

Load the database on the cluster with this command line :  

`scp path/of/the/database/on/your/computer username@genossh.genouest.org:/path/on/the/cluster`

### Mobile-OG
Download the database Mobile-OG (Beatrix 1.6 v1) using this link :
[Mobile-OG database](https://mobileogdb.flsi.cloud.vt.edu/entries/database_download)

Create a repertory on the cluster :  

`mkdir databases/Mobile-OG_database`

Load the database on the cluster with this command line :  

`scp path/of/the/database/on/your/computer username@genossh.genouest.org:/path/on/the/cluster`

Extract the database :
```
cd databases/Mobile-OG_database
gunzip database_name
```

### PlasmidFinder requirements
Run this command line in your databases repertory :

```
#Clone database from git repository
git clone https://bitbucket.org/genomicepidemiology/plasmidfinder_db.git
cd plasmidfinder_db
#Concatenate all the databases
cat *.fsa > plasmidfinder_all.fasta
```

## C-Data
This pipeline was developped with the Nanopore GridION and PromethION Mock Microbial Community Data available on :
[Data Mockcommunity](https://github.com/LomanLab/mockcommunity)

## D-Tools
### 1.Quality control
#### 1.1 NanoPlot (v.1.28.4)
NanoPlot is a visualization tool used to assess the quality of long-read sequencing data by generating plots and summary statistics such as read length distributions and quality scores. For this tool we used this [biocontainer](https://quay.io/repository/biocontainers/nanoplot?tab=tags&tag=1.28.4--py_0).

- **Input** : Oxford Nanopore Technology data files (fastq) *ONT_ch*

- **Output** : quality control report (html)

- **Commandline** :  
 
```
NanoPlot -t ${cpus} --fastq ${fastq} -o ${output}
```

#### 1.2 Quast (v.5.3.0)

- **Input** :

- **Output** :

- **Commandline** :
```
```

#### 1.3 CheckM2 

- **Input** :

- **Output** :

- **Commandline** :
```
```

### 2. Trimming and Filtering
#### 2.1 Porechop-ABI
Porechop_ABI is a tool used to process adapter sequences in ONT reads. For this tool we used this [biocontainer](https://quay.io/repository/biocontainers/porechop_abi?tab=tags&tag=0.5.1--py310h275bdba_0)

- **Input** : Oxford Nanopore Technology data files (fastq) *ONT_ch*

- **Output** : Trimmed Oxford Nanopore Technology data files (fastq) *trim_ch*

- **Commandline** :  

```
porechop_abi -abi -t ${cpus} -i ${fastq} -o ${output}
```

#### 2.2 NanoFilt
NanoFilt is a tool used to filtering reads of long-read sequencing data on quality and/or read length, and optional trimming after passing filters. For this tool we used this [biocontainer](https://quay.io/repository/biocontainers/nanofilt?tab=tags&tag=1.1.3--py35_0)

- **Input** : Trimmed Oxford Nanopore Technology data files (fastq) *trim_ch*

- **Output** : Filtered Oxford Nanopore Technology data files (fastq) *filt_ch*

- **Commandline** :  

```
cat ${fastq} | NanoFilt -l ${minimum_read_lenght} -q ${quality} > ${output}
```

### 3. Alignment (optional : only if the host genome is known)
#### 3.1 Minimap2

- **Input** : Filtered Oxford Nanopore Technology data files (fastq) *filt_ch*

- **Output** : Aligned Oxford Nanopore Technology data files (sam) *aln_ch*

- **Commandline** :  

```
minimap2 -ax map-ont ${reference} ${fastq} > ${output}
```

#### 3.2 Samtools

- **Input** : Aligned Oxford Nanopore Technology data files (sam) *aln_ch*

- **Output** : Sorted of unmaped Oxford Nanopore Technology data files (bam) *sorted_ch*

- **Commandline** :  

```
samtools view -bS -@ ${cpus} -f 4 ${fastq} > ${output}
samtools sort -@ ${cpus} -n ${ouput_samtools_view} -o ${output}
```

#### 3.3 Bedtools

- **Input** : Sorted of unmaped Oxford Nanopore Technology data files (bam) *sorted_ch*

- **Output** : Fitted Oxford Nanopore Technology data files (fastq) *fitted_ch*

- **Commandline** :  

```
bedtools bamtofastq -i ${fastq} -fq ${output}
```

### 4. Taxonomic classification
#### 4.1 Kraken2

- **Input** : Fitted Oxford Nanopore Technology data files (fastq) *fitted_ch*

- **Output** : Taxonomic reads classification (html, kraken) *kraken_ch* 

- **Commandline** :  
```
kraken2 --threads ${cpus} --db ${kraken_database} --report ${report_output_name} --output ${output} --use-names ${fastq}
```

#### 4.2 Python script collect_read_id.py

- **Input** : Taxonomic reads classification (kraken) *kraken_ch*

- **Output** : File with all the read ID (txt) *ID_ch*

- **Commandline** :

#### 4.3 Seqkit 

- **Input** : File with all the read ID (txt) *id_ch* & Fitted Oxford Nanopore Technology data files (fastq) *fitted_ch*Fitted Oxford Nanopore Technology data files (fastq) *fitted_ch*

- **Output** : File with just Bacterial and unknown reads (fastq) *id2_ch* 

- **Commandline** :  

```
seqkit grep -f ${ID_file} ${fastq} -o ${output}
```

### 5. Assembly
#### 5.1 Flye

- **Input** : File with just Bacterial and unknown reads (fastq) *id2_ch*

- **Output** : Assembly reads (fasta) *asmbl_ch*

- **Commandline** :  
```
flye --nano-raw ${fastq} --out-dir ${output_directory} --threads ${cpus} --meta
```

### 6. Polishing
#### 6.1 Racon

- **Input** :

- **Output** :

- **Commandline** :
```
racon ${fastq} ${sam} ${fasta} -t ${cpus} > racon.fasta
```

#### 6.2 Medaka

- **Input** :

- **Output** :

- **Commandline** :
```
medaka_consensus -i ${fastq} -d ${fasta} -t ${cpus} -o ${output_directory} -m ${modele}
```

### 7. Binning
#### 7.1 Semibin2

- **Input** :

- **Output** :

- **Commandline** :
```
SemiBin2 single_easy_bin -i  ${fasta} -b ${bam} -o ${output_directory} --threads ${cpus} --environment ${env}
```

### 8. Annotation
#### 8.1 Prodigale 

- **Input** :

- **Output** :

- **Commandline** :
```
prodigal -i ${fasta} -a ${output}.faa -d ${output}.fna -o ${output}.gff -p meta
```

#### 8.2 Prokka

- **Input** :

- **Output** :

- **Commandline** :
```
prokka --metagenome --outdir ${output_directory} ${fasta}
```

### 9. ARG/BEG/MGE research
#### 9.1 Abricate

- **Input** :

- **Output** :

- **Commandline** :
```
abricate --db ${database} ${fasta} > ${output}
```

#### 9.2 Blast

- **Input** :

- **Output** :

- **Commandline** :
```
blastn -query ${fasta} -db ${database} -out ${output} -outfmt 6
```
