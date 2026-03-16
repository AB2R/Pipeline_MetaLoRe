process blast_mobileOG {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/9-annotation/7-blast_mobileOG",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_mobileOG",     mode: 'copy', pattern: 'blast_mobileOG.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_mobileOG.cmd'

    // Workflow input stream
    input:
        each(bins_files_ch)
        path(params.mobileOG_db)

    // Workflow output stream
    output:
        path("*.tab"), emit: mobileOG_ch
        // we also collect commands executed and log files
        path("blast_mobileOG.log")
        path("blast_mobileOG.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_mobileOG.sh ${bins_files_ch} ${params.mobileOG_db} blast_mobileOG.cmd &> blast_mobileOG.log 2>&1
    """
}
