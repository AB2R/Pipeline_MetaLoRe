process abricate_reads {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/7-genes_research/1-abricate_reads",   mode: 'copy', pattern: '*ncbi.tab'
    publishDir "${params.resultdir}/7-genes_research/1-abricate_reads",   mode: 'copy', pattern: '*card.tab'
    publishDir "${params.resultdir}/7-genes_research/1-abricate_reads",   mode: 'copy', pattern: '*resfinder.tab'
    publishDir "${params.resultdir}/7-genes_research/1-abricate_reads",   mode: 'copy', pattern: '*megares.tab'
    publishDir "${params.resultdir}/7-genes_research/1-abricate_reads",   mode: 'copy', pattern: '*plasmidfinder.tab'
    publishDir "${params.resultdir}/logs/abricate_reads",     mode: 'copy', pattern: 'abricate_reads.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'abricate_reads.cmd'

    // Workflow input stream
    input:
        path(genes_ch)
    // Workflow output stream
    output:
        path("*ncbi.tab"), emit: ab_ncbi_ch
	path("*card.tab"), emit: ab_card_ch
	path("*resfinder.tab"), emit: ab_resfinder_ch
	path("*megares.tab"), emit: ab_megares_ch
	path("*plasmidfinder.tab"), emit: ab_plasmidf_ch
        // we also collect commands executed and log files
        path("abricate_reads.log")
        path("abricate_reads.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    abricate_reads.sh ${genes_ch} ${params.db2_abricate} ${params.db3_abricate} ${params.db4_abricate} ${params.db5_abricate} abricate_reads.cmd &> abricate_reads.log 2>&1
    """
}
