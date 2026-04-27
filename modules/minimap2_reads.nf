process minimap2_reads {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/6-abundance/1-minimap2_reads",   mode: 'copy', pattern: '*.sam'
    publishDir "${params.resultdir}/logs/minimap2_reads",     mode: 'copy', pattern: 'minimap2_reads.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'minimap2_reads.cmd'

    // Workflow input stream
    input:
        path(id2_ch)
	path(genes_ch)

    // Workflow output stream
    output:
        path("*.sam"), emit: aln_reads_ch
        // we also collect commands executed and log files
        path("minimap2_reads.log")
        path("minimap2_reads.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    minimap2_reads.sh ${genes_ch} ${id2_ch} minimap2_reads.cmd &> minimap2_reads.log 2>&1
    """
}
