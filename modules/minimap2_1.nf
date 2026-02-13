process minimap2_1 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'highmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-alignment_1/1-minimap2_1",   mode: 'copy', pattern: '*.sam'
    publishDir "${params.resultdir}/logs/minimap2_1",     mode: 'copy', pattern: 'minimap2_1.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'minimap2_1.cmd'

    // Workflow input stream
    input:
        path(filt_ch)

    // Workflow output stream
    output:
        path("*.sam"), emit: aln_ch
        // we also collect commands executed and log files
        path("minimap2_1.log")
        path("minimap2_1.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    minimap2_1.sh ${params.ref_genome} ${filt_ch} minimap2_1.cmd &> minimap2_1.log 2>&1
    """
}
