process abricate {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/1-abricate",   mode: 'copy', pattern: '*ncbi.tab'
    publishDir "${params.resultdir}/8-genes_research/1-abricate",   mode: 'copy', pattern: '*card.tab'
    publishDir "${params.resultdir}/8-genes_research/1-abricate",   mode: 'copy', pattern: '*resfinder.tab'
    publishDir "${params.resultdir}/logs/abricate",     mode: 'copy', pattern: 'abricate.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'abricate.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(genes_ch)
    // Workflow output stream
    output:
        tuple val(sample_id), path("*ncbi.tab"), emit: ab_ncbi_ch
        tuple val(sample_id), path("*card.tab"), emit: ab_card_ch
        tuple val(sample_id), path("*resfinder.tab"), emit: ab_resfinder_ch
        // we also collect commands executed and log files
        path("abricate.log")
        path("abricate.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    abricate.sh ${genes_ch} ${params.db2_abricate} ${params.db3_abricate} abricate.cmd &> abricate.log 2>&1
    """
}
