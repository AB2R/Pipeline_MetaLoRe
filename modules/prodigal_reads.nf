process prodigal_reads {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/5-annotation/1-prodigal_reads",   mode: 'copy', pattern: '*.faa'
    publishDir "${params.resultdir}/5-annotation/1-prodigal_reads",   mode: 'copy', pattern: '*.fna'
    publishDir "${params.resultdir}/5-annotation/1-prodigal_reads",   mode: 'copy', pattern: '*.gbk'
    publishDir "${params.resultdir}/logs/prodigal_reads",     mode: 'copy', pattern: 'prodigal_reads.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'prodigal_reads.cmd'

    // Workflow input stream
    input:
        path(id2_ch)

    // Workflow output stream
    output:
        path("*.faa"), emit: prot_ch
        path("*.fna"), emit: genes_ch
        path("*.gbk")
        // we also collect commands executed and log files
        path("prodigal_reads.log")
        path("prodigal_reads.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    prodigal_reads.sh ${id2_ch} prodigal_reads.cmd &> prodigal_reads.log 2>&1
    """
}
