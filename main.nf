#!/usr/bin/env nextflow

nextflow.enable.dsl=2

def helpMessage() {
    // Add to this help message with new command line parameters
    log.info"""

    Usage:
2.2.1--pyhdfd78af_0
    The typical command for running the pipeline is as follows:

        nextflow run main.nf -c cluster.config -profile singularity,custom [params]

    using following [params] :

Mandatory:
--ONT_path		[path]	Absolute path to ONT data files.
--ref_genome            [path]  Absolute path to reference genome
--db_kraken             [path]  Absolute path to kraken database
--model_medaka          [str]   Name of the model
--env_semibin           [str]   Name of the environment
--db_checkm2            [path]  Absolute path to checkm2 database
--db_abricate           [str]   Name of the databes used by abricate
--db_phylophlan         [str]   Name of the databes used by phylophlan
--diversity_phylophlan  [str]   Parameter for the level of diversity used by phylophlan
    
Other options:
--outdir                [path]	The output directory where the results will be saved.
-w/--workdir            [path]	The temporary directory where intermediate data will be saved.
-name                   [str]	Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.
--projectName           [str]	Name of the project.

        """.stripIndent()
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

// SET UP CONFIGURATION VARIABLES
// Has the run name been specified by the user?
// this has the bonus effect of catching both -name and --name
custom_runName = params.name
if (!(workflow.runName ==~ /[a-z]+_[a-z]+/)) {
    custom_runName = workflow.runName
}

//Copy config files to output directory for each run
paramsfile = file("$baseDir/conf/base.config", checkIfExists: true)
paramsfile.copyTo("$params.outdir/00_pipeline_info/base.config")

// PIPELINE INFO
def summary = [:]
if (workflow.revision) summary['Pipeline Release'] = workflow.revision
summary['Run Name'] = custom_runName ?: workflow.runName
summary['Project Name'] = params.projectName
summary['User'] = workflow.userName
summary['Output dir'] = params.outdir
summary['Launch dir'] = workflow.launchDir
summary['Working dir'] = workflow.workDir
summary['Script dir'] = workflow.projectDir
summary['ONT file(s)'] = params.ONT_path
summary['Reference Genome'] = params.ref_genome
summary['Kraken2 database'] = params.db_kraken
summary['Model Medaka'] = params.model_medaka
summary['Environment SemiBin'] = params.env_semibin
summary['Checkm2 database'] = params.db_checkm2
summary['Abricate databases'] = params.db_abricate
summary['Phylophlan database'] = params.db_phylophlan
summary['Phylophlan diversity'] = params.diversity_phylophlan
log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
log.info "-\033[91m--------------------------------------------------\033[0m-"

// Check hostnames against configured profiles
checkHostname()

/*
 * IMPORTING MODULES
 */
include { nanoplot }        from './modules/nanoplot.nf'
include { porechop_abi }    from './modules/porechop_abi.nf'
include { nanofilt }        from './modules/nanofilt.nf'
include { minimap2_1 }      from './modules/minimap2_1.nf'
include { samtools_1 }      from './modules/samtools_1.nf'
include { bedtools }        from './modules/bedtools.nf'
include { kraken2 }         from './modules/kraken2.nf'
include { collect_read_id } from './modules/collect_read_id.nf'
include { seqkit }          from './modules/seqkit.nf'
include { flye }            from './modules/flye.nf'
include { minimap2_2 }      from './modules/minimap2_2.nf'
include { racon_1 }         from './modules/racon_1.nf'
include { minimap2_3 }      from './modules/minimap2_3.nf'
include { racon_2 }         from './modules/racon_2.nf'
include { minimap2_4 }      from './modules/minimap2_4.nf'
include { samtools_2 }      from './modules/samtools_2.nf'
include { medaka }          from './modules/medaka.nf'
include { quast }           from './modules/quast.nf'
include { semibin }         from './modules/semibin.nf'
include { checkm2 }         from './modules/checkm2.nf'
include { prodigal }        from './modules/prodigal.nf'
include { prokka }          from './modules/prokka.nf'
include { amrplusplus }     from './modules/amrplusplus.nf'
include { abricate }        from './modules/abricate.nf'
include { phylophlan }      from './module/phylophlan.nf'

/*
 * CREATE INPUT CHANNELS
 */
ONT_ch = Channel.fromPath("${params.ONT_path}")

/*
 * RUN MAIN WORKFLOW
 */
workflow {
    
    // Quality control of ONT raw reads
    nanoplot(ONT_ch)

    // Trimming of ONT raw read
    porechop_abi(ONT_ch)

    // Filtering of ONT raw data
    nanofilt(porechop_abi.out.trim_ch.collect())

    // Mapping ONT reds on reference genome
    minimap2_1(nanofilt.out.filt_ch.collect())

    // Extracting unmaped reads and sorting alignments
    samtools_1(minimap2_1.out.aln_ch.collect())

    // BAM to FASTQ conversion
    bedtools(samtools_1.out.bam_ch.collect())

    // Taxonomic classification
    kraken2(bedtools.out.fitted_ch.collect())

    // Read ID collection
    collect_read_id(kraken2.out.kraken_ch.collect())

    // Read extraction
    seqkit(collect_read_id.out.id_ch.collect(), bedtools.out.fitted_ch.collect())

    // Assembly 
    flye(seqkit.out.id2_ch.collect())

    // Mappinf ONT reads on assembly
    minimap2_2(flye.out.asmbl_ch.collect(), seqkit.out.id2_ch.collect())

    // Polishing assembly reads
    racon_1(seqkit.out.id2_ch.collect(), minimap2_2.out.aln2_ch.collect(), flye.out.asmbl_ch.collect())

    // Alignment on polish assembly
    minimap2_3(racon_1.out.polish1_ch.collect(), seqkit.out.id2_ch.collect())

    // Polishing assembly reads
    racon_2(seqkit.out.id2_ch.collect(), minimap2_3.out.aln3_ch.collect(), racon_1.out.polish1_ch.collect())

    // Alignment on polish assembly
    minimap2_4(racon_2.out.polish2_ch.collect(), seqkit.out.id2_ch.collect())

    // Sorting alignments
    samtools_2(minimap2_4.out.aln4_ch.collect())

    // Polishing assembly reads
    medaka(samtools_2.out.bam2_ch.collect(), racon_2.out.polish2_ch.collect())

    // Quality control of assembly
    quast(flye.out.asmbl_ch.collect(), racon_2.out.polish2_ch.collect(), medaka.out.polish3_ch.collect())

    // Binning of assembly
    semibin(medaka.out.polish3_ch.collect(), samtools_2.out.bam2_ch.collect())
 
    // Channel creation for checkm2 and Prokka
    //bins_dir_ch = semibin.out.binned_ch
    //bins_files_ch = bins_dir_ch.flatMap { dir -> Channel.fromPath("${dir}/*.fa.gz")}

    // Quality control of binning
    checkm2(semibin.out.bins_dir_ch.collect())

    // Functionnal annotation
    prodigal(flye.out.asmbl_ch.collect())

    // Annotation
    prokka(semibin.out.bins_files_ch.collect())

    // AMR genes research
    //amrplusplus()

    // ARG research
    abricate(semibin.out.bins_files_ch.collect())

    // Taxonomy
    //phylophlan(semibin.out.bins_dir_ch.collect())
}

/*
 * Completion notification
 */
workflow.onComplete {
    c_green = params.monochrome_logs ? '' : "\033[0;32m";
    c_purple = params.monochrome_logs ? '' : "\033[0;35m";
    c_red = params.monochrome_logs ? '' : "\033[0;31m";
    c_reset = params.monochrome_logs ? '' : "\033[0m";
    
    def msg = """\
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """
    .stripIndent()
    if (workflow.success) {
        log.info "-${c_purple}[Workflow info]${c_green} workflow completed successfully${c_reset}-"
    } else {
        checkHostname()
        log.info "-${c_purple}[Workflow info]${c_red} workflow completed with errors${c_reset}-"
    }
}

/*
 * Other functions
 */

def checkHostname() {
    def c_reset = params.monochrome_logs ? '' : "\033[0m"
    def c_white = params.monochrome_logs ? '' : "\033[0;37m"
    def c_red = params.monochrome_logs ? '' : "\033[1;91m"
    def c_yellow_bold = params.monochrome_logs ? '' : "\033[1;93m"
    if (params.hostnames) {
        def hostname = "hostname".execute().text.trim()
        params.hostnames.each { prof, hnames ->
            hnames.each { hname ->
                if (hostname.contains(hname) && !workflow.profile.contains(prof)) {
                    log.error "====================================================\n" +
                            "  ${c_red}WARNING!${c_reset} You are running with `-profile $workflow.profile`\n" +
                            "  but your machine hostname is ${c_white}'$hostname'${c_reset}\n" +
                            "  ${c_yellow_bold}It's highly recommended that you use `-profile $prof${c_reset}`\n" +
                            "============================================================"
                }
            }
        }
    }
}


