process nanofilt {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/2-trimming_filtering/2-nanofilt",   mode: 'copy', pattern: '*.fastq'
    publishDir "${params.resultdir}/logs/nanofilt",     mode: 'copy', pattern: 'nanofilt.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'nanofilt.cmd'

    // Workflow input stream
    input:
        path(trim_ch)

    // Workflow output stream
    output:
        path("*.fastq"), emit: filt_ch
        // we also collect commands executed and log files
        path("nanofilt.log")
        path("nanofilt.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    nanofilt.sh ${trim_ch} ${params.length_min} ${params.quality} nanofilt.cmd &> nanofilt.log 2>&1
    """
}
