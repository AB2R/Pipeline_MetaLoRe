process blast_db_mobileOG {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${baseDir}/databases",   mode: 'copy', pattern: 'mobileOG-db*'
    publishDir "${params.resultdir}/logs/blast_db_mobileOG",     mode: 'copy', pattern: 'blast_db_mobileOG.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_db_mobileOG.cmd'

    // Workflow input stream
    input:
        path(params.db_mobileOG_path)

    // Workflow output stream
    output:
        path("mobileOG-db*")
        // we also collect commands executed and log files
        path("blast_db_mobileOG.log")
        path("blast_db_mobileOG.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_db_mobileOG.sh ${params.db_mobileOG_path} ${params.db_mobileOG_type} blast_db_mobileOG.cmd &> blast_db_mobileOG.log 2>&1
    """
}
