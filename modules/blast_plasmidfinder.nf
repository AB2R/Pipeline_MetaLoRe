process blast_plasmidfinder {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/2-blast/3-blast_plasmidfinder",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_plasmidfinder",     mode: 'copy', pattern: 'blast_plasmidfinder.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_plasmidfinder.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(genes_ch)
        path(params.plasmidfinder_db)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*.tab"), emit: plasmidf_ch
        // we also collect commands executed and log files
        path("blast_plasmidfinder.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_plasmidfinder.sh ${genes_ch} ${params.plasmidfinder_db} &> blast_plasmidfinder.log 2>&1
    """
}
