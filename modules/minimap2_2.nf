process minimap2_2 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'highmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/6-alignment_2/1-minimap2_2",   mode: 'copy', pattern: '*.sam'
    publishDir "${params.resultdir}/logs/minimap2_2",     mode: 'copy', pattern: 'minimap2_2.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'minimap2_2.cmd'

    // Workflow input stream
    input:
        path(asmbl_ch)
	path(id2_ch)

    // Workflow output stream
    output:
        path("*.sam"), emit: aln2_ch
        // we also collect commands executed and log files
        path("minimap2_2.log")
        path("minimap2_2.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    minimap2_2.sh ${asmbl_ch} ${id2_ch} minimap2_2.cmd &> minimap2_2.log 2>&1
    """
}
