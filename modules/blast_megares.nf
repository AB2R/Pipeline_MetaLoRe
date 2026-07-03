process blast_megares {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/2-blast/1-blast_megares",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_megares",     mode: 'copy', pattern: 'blast_megares.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_megares.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(genes_ch)
        path(params.megares_db)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*.tab"), emit: megares_ch
        // we also collect commands executed and log files
        path("blast_megares.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_megares.sh ${genes_ch} ${params.megares_db} &> blast_megares.log 2>&1
    """
}
