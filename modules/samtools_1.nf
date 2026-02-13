process samtools_1 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-alignment_1/2-samtools_1",   mode: 'copy', pattern: 'unmaped*'
    publishDir "${params.resultdir}/3-alignment_1/2-samtools_1",   mode: 'copy', pattern: 'sorted*'
    publishDir "${params.resultdir}/logs/samtools_1",     mode: 'copy', pattern: 'samtools_1.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'samtools_1.cmd'

    // Workflow input stream
    input:
        path(aln_ch)

    // Workflow output stream
    output:
	path("unmaped*")
        path("sorted*"), emit: bam_ch
        // we also collect commands executed and log files
        path("samtools_1.log")
        path("samtools_1.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    samtools_1.sh ${task.cpus} ${aln_ch} samtools_1.cmd &> samtools_1.log 2>&1
    """
}
