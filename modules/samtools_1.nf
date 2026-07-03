process samtools_1 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/6-abundance/2-samtools_1",   mode: 'copy', pattern: '*.bam'
    publishDir "${params.resultdir}/6-abundance/2-samtools_1",   mode: 'copy', pattern: '*_sorted.bam'
    publishDir "${params.resultdir}/6-abundance/2-samtools_1",   mode: 'copy', pattern: '*.txt'
    publishDir "${params.resultdir}/logs/samtools_1",     mode: 'copy', pattern: 'samtools_1.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'samtools_1.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(aln1_ch)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*.bam")
        tuple val(sample_id), path("*_sorted.bam")
	tuple val(sample_id), path("*.txt"), emit: gcpm_ch
        // we also collect commands executed and log files
        path("samtools_1.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    samtools_1.sh ${task.cpus} ${aln1_ch} &> samtools_1.log 2>&1
    """
}
