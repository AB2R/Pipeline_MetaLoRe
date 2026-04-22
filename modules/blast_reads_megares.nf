process blast_reads_megares {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/7-genes_research/2-blast_reads/1-blast_reads_megares",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_reads_megares",     mode: 'copy', pattern: 'blast_reads_megares.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_reads_megares.cmd'

    // Workflow input stream
    input:
        path(genes_ch)
        path(params.megares_db)

    // Workflow output stream
    output:
        path("*.tab"), emit: reads_megares_ch
        // we also collect commands executed and log files
        path("blast_reads_megares.log")
        path("blast_reads_megares.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_reads_megares.sh ${genes_ch} ${params.megares_db} blast_reads_megares.cmd &> blast_reads_megares.log 2>&1
    """
}
