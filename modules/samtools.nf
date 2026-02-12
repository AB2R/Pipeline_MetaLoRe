process samtools {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-Alignment/2-samtools",   mode: 'copy', pattern: 'unmaped*'
    publishDir "${params.resultdir}/3-Alignment/2-samtools",   mode: 'copy', pattern: 'sorted*'
    publishDir "${params.resultdir}/logs/samtools",     mode: 'copy', pattern: 'samtools.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'samtools.cmd'

    // Workflow input stream
    input:
        path(aln_ch)

    // Workflow output stream
    output:
	path("unmaped*")
        path("sorted*"), emit: bam_ch
        // we also collect commands executed and log files
        path("samtools.log")
        path("samtools.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    samtools.sh ${task.cpus} ${aln_ch} samtools.cmd &> samtools.log 2>&1
    """
}
