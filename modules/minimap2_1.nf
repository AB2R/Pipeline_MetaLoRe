process minimap2_1 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/6-abundance/1-minimap2_1",   mode: 'copy', pattern: '*.sam'
    publishDir "${params.resultdir}/logs/minimap2_1",     mode: 'copy', pattern: 'minimap2_1.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'minimap2_1.cmd'

    // Workflow input stream
    input:
        path(polish3_ch)
	path(genes_ch)

    // Workflow output stream
    output:
        path("*.sam"), emit: aln1_ch
        // we also collect commands executed and log files
        path("minimap2_1.log")
        path("minimap2_1.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    minimap2_1.sh ${genes_ch} ${polish3_ch} minimap2_1.cmd &> minimap2_1.log 2>&1
    """
}
