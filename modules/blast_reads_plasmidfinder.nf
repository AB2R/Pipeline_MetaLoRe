process blast_reads_plasmidfinder {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/7-genes_research/2-blast_reads/3-blast_reads_plasmidfinder",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_reads_plasmidfinder",     mode: 'copy', pattern: 'blast_reads_plasmidfinder.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_reads_plasmidfinder.cmd'

    // Workflow input stream
    input:
        each(genes_ch)
        path(params.plasmidfinder_db)

    // Workflow output stream
    output:
        path("*.tab"), emit: reads_plasmidf_ch
        // we also collect commands executed and log files
        path("blast_reads_plasmidfinder.log")
        path("blast_reads_plasmidfinder.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_reads_plasmidfinder.sh ${genes_ch} ${params.plasmidfinder_db} blast_reads_plasmidfinder.cmd &> blast_reads_plasmidfinder.log 2>&1
    """
}
