process blast_reads_mobileOG {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'mobileOGmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/2-blast_reads/2-blast_reads_mobileOG",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_reads_mobileOG",     mode: 'copy', pattern: 'blast_reads_mobileOG.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_reads_mobileOG.cmd'

    // Workflow input stream
    input:
        each(prot_ch)
        path(params.mobileOG_db)

    // Workflow output stream
    output:
        path("*.tab"), emit: reads_mobileOG_ch
        // we also collect commands executed and log files
        path("blast_reads_mobileOG.log")
        path("blast_reads_mobileOG.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_reads_mobileOG.sh ${prot_ch} ${params.mobileOG_db} ${task.cpus} blast_reads_mobileOG.cmd &> blast_reads_mobileOG.log 2>&1
    """
}
