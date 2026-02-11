#!/usr/bin/env nextflow

nextflow.enable.dsl=2

def helpMessage() {
    // Add to this help message with new command line parameters
    log.info"""

    Usage:

    The typical command for running the pipeline is as follows:

        nextflow run main.nf -c cluster.config -profile singularity,custom [params]

    using following [params] :

Mandatory:
--ONT_path		[path]	Absolute path to ONT data files.

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
log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
log.info "-\033[91m--------------------------------------------------\033[0m-"

// Check hostnames against configured profiles
checkHostname()

/*
 * IMPORTING MODULES
 */
include { nanoplot }      from './modules/nanoplot.nf'
include { porechop_abi }  from './modules/porechop_abi.nf'
include { nanofilt }      from './modules/nanofilt.nf'
include { minimap2 }      from './modules/minimap2.nf'

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
    // minimap2(nanofilt.out.filt_ch.collect())
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


