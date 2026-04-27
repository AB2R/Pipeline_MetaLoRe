process samtools_reads {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/6-abundance/2-samtools_reads",   mode: 'copy', pattern: '*.bam'
    publishDir "${params.resultdir}/6-abundance/2-samtools_reads",   mode: 'copy', pattern: '*_sorted.bam'
    publishDir "${params.resultdir}/6-abundance/2-samtools_reads",   mode: 'copy', pattern: '*.txt'
    publishDir "${params.resultdir}/logs/samtools_reads",     mode: 'copy', pattern: 'samtools_reads.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'samtools_reads.cmd'

    // Workflow input stream
    input:
        path(aln_reads_ch)

    // Workflow output stream
    output:
        path("*.bam")
        path("*_sorted.bam")
	path("*.txt")
        // we also collect commands executed and log files
        path("samtools_reads.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    samtools_reads.sh ${task.cpus} ${aln_reads_ch} &> samtools_reads.log 2>&1
    """
}
