process bedtools {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-alignment_1/3-bedtools",   mode: 'copy', pattern: '*.fastq'
    publishDir "${params.resultdir}/logs/bedtools",     mode: 'copy', pattern: 'bedtools.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'bedtools.cmd'

    // Workflow input stream
    input:
        path(bam_ch)

    // Workflow output stream
    output:
        path("*.fastq"), emit: fitted_ch
        // we also collect commands executed and log files
        path("bedtools.log")
        path("bedtools.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    bedtools.sh ${bam_ch} bedtools.cmd &> bedtools.log 2>&1
    """
}
