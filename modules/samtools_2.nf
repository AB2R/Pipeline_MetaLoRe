process samtools_2 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-assembly_alignment_polishing/7-samtools_2",   mode: 'copy', pattern: '*.bam'
    publishDir "${params.resultdir}/logs/samtools_2",     mode: 'copy', pattern: 'samtools_2.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'samtools_2.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(aln4_ch)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*.bam"), emit: bam2_ch
        // we also collect commands executed and log files
        path("samtools_2.log")
        path("samtools_2.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    samtools_2.sh ${task.cpus} ${aln4_ch} samtools_2.cmd &> samtools_2.log 2>&1
    """
}
