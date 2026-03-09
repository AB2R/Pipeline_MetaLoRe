process blast_db_megares {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${baseDir}/databases",   mode: 'copy', pattern: 'megares_database_v3*'
    publishDir "${params.resultdir}/logs/blast_db_megares",     mode: 'copy', pattern: 'blast_db_megares.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_db_megares.cmd'

    // Workflow input stream
    input:
        path(params.db_megares_path)

    // Workflow output stream
    output:
        path("megares_database_v3*")
        // we also collect commands executed and log files
        path("blast_db_megares.log")
        path("blast_db_megares.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_db_megares.sh ${params.db_megares_path} ${params.db_megares_type} blast_db_megares.cmd &> blast_db_megares.log 2>&1
    """
}
