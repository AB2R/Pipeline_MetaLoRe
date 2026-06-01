process blast_mobileog {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'mobileOGmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/2-blast/2-blast_mobileog",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_mobileog",     mode: 'copy', pattern: 'blast_mobileog.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_mobileog.cmd'

    // Workflow input stream
    input:
        each(prot_ch)
        path(params.mobileOG_db)

    // Workflow output stream
    output:
        path("*.tab"), emit: mobileog_ch
        // we also collect commands executed and log files
        path("blast_mobileog.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_mobileog.sh ${prot_ch} ${params.mobileOG_db} ${task.cpus} &> blast_mobileog.log 2>&1
    """
}
