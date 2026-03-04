process abricate {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/9-annotation/3-abricate",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/abricate",     mode: 'copy', pattern: 'abricate.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'abricate.cmd'

    // Workflow input stream
    input:
        each(bins_files_ch)

    // Workflow output stream
    output:
        path("*.tab")
        // we also collect commands executed and log files
        path("abricate.log")
        path("abricate.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    abricate.sh ${bins_files_ch} ${params.db2_abricate} ${params.db3_abricate} ${params.db4_abricate} ${params.db5_abricate} abricate.cmd &> abricate.log 2>&1
    """
}
