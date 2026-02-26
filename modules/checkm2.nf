process checkm2 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-binning/2-checkm2",   mode: 'copy', pattern: 'checkm2_out'
    publishDir "${params.resultdir}/logs/checkm2",     mode: 'copy', pattern: 'checkm2.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'checkm2.cmd'

    // Workflow input stream
    input:
        path(binned_ch)

    // Workflow output stream
    output:
        path("checkm2_out")
        // we also collect commands executed and log files
        path("checkm2.log")
        path("checkm2.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    checkm2.sh ${binned_ch} checkm2_out ${task.cpus} ${params.db_checkm2} checkm2.cmd &> checkm2.log 2>&1
    """
}
