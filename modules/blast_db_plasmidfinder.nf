process blast_db_plasmidfinder {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${baseDir}/databases/plasmidfinder_db",   mode: 'copy', pattern: 'plasmidfinder_all_db*'
    publishDir "${params.resultdir}/logs/blast_db_plasmidfinder",     mode: 'copy', pattern: 'blast_db_plasmidfinder.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_db_plasmidfinder.cmd'

    // Workflow input stream
    input:
        path(params.db_plasmidfinder_path)

    // Workflow output stream
    output:
        path("plasmidfinder_all_db*")
        // we also collect commands executed and log files
        path("blast_db_plasmidfinder.log")
        path("blast_db_plasmidfinder.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_db_plasmidfinder.sh ${params.db_plasmidfinder_path} ${params.db_plasmidfinder_type} blast_db_plasmidfinder.cmd &> blast_db_plasmidfinder.log 2>&1
    """
}
