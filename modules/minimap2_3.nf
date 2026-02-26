process minimap2_3 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'highmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/7-polishing/2-minimap2_3",   mode: 'copy', pattern: '*.sam'
    publishDir "${params.resultdir}/logs/minimap2_3",     mode: 'copy', pattern: 'minimap2_3.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'minimap2_3.cmd'

    // Workflow input stream
    input:
        path(polish1_ch)
        path(id2_ch)

    // Workflow output stream
    output:
        path("*.sam"), emit: aln3_ch
        // we also collect commands executed and log files
        path("minimap2_3.log")
        path("minimap2_3.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    minimap2_3.sh ${polish1_ch} ${id2_ch} minimap2_3.cmd &> minimap2_3.log 2>&1
    """
}
