process seqkit {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/4-classification/3-seqkit",   mode: 'copy', pattern: '*.fastq'
    publishDir "${params.resultdir}/logs/seqkit",     mode: 'copy', pattern: 'seqkit.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'seqkit.cmd'

    // Workflow input stream
    input:
        path(id_ch)
        path(fitted_ch)

    // Workflow output stream
    output:
        path("*.fastq"), emit: id2_ch
        // we also collect commands executed and log files
        path("seqkit.log")
        path("seqkit.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    seqkit.sh ${id_ch} ${fitted_ch} seqkit.cmd &> seqkit.log 2>&1
    """
}
