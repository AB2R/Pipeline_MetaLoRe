process blast_plasmidfinder {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/9-annotation/8-blast_plasmidfinder",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_plasmidfinder",     mode: 'copy', pattern: 'blast_plasmidfinder.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_plasmidfinder.cmd'

    // Workflow input stream
    input:
        each(bins_files_ch)
        path(params.plasmidfinder_db)

    // Workflow output stream
    output:
        path("*.tab"), emit: plasmidf_ch
        // we also collect commands executed and log files
        path("blast_plasmidfinder.log")
        path("blast_plasmidfinder.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_plasmidfinder.sh ${bins_files_ch} ${params.plasmidfinder_db} blast_plasmidfinder.cmd &> blast_plasmidfinder.log 2>&1
    """
}
