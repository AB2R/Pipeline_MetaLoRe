process minimap2 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'highmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-Alignment/1-minimap",   mode: 'copy', pattern: '*.sam'
    publishDir "${params.resultdir}/logs/minimap2",     mode: 'copy', pattern: 'minimap2.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'minimap2.cmd'

    // Workflow input stream
    input:
        path(filt_ch)

    // Workflow output stream
    output:
        path("*.sam"), emit: aln_ch
        // we also collect commands executed and log files
        path("minimap2.log")
        path("minimap2.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    minimap2.sh ${params.ref_genome} ${filt_ch} minimap2.cmd &> minimap2.log 2>&1
    """
}
