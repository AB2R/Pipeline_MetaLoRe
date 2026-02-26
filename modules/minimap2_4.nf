process minimap2_4 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'highmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/7-polishing/4-minimap2_4",   mode: 'copy', pattern: '*.sam'
    publishDir "${params.resultdir}/logs/minimap2_4",     mode: 'copy', pattern: 'minimap2_4.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'minimap2_4.cmd'

    // Workflow input stream
    input:
        path(polish2_ch)
        path(id2_ch)

    // Workflow output stream
    output:
        path("*.sam"), emit: aln4_ch
        // we also collect commands executed and log files
        path("minimap2_4.log")
        path("minimap2_4.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    minimap2_4.sh ${polish2_ch} ${id2_ch} minimap2_4.cmd &> minimap2_4.log 2>&1
    """
}
