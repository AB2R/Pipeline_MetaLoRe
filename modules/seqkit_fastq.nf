process seqkit_fastq {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/2-trimming_filtering/1-seqkit_fastq",   mode: 'copy', pattern: '*.fastq'
    publishDir "${params.resultdir}/logs/seqkit_fastq",     mode: 'copy', pattern: 'seqkit_fastq.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'seqkit_fastq.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(ONT_ch)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*.fastq"), emit: cleanfq_ch
        // we also collect commands executed and log files
        path("seqkit_fastq.log")
        path("seqkit_fastq.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    seqkit_fastq.sh ${ONT_ch} seqkit_fastq.cmd &> seqkit_fastq.log 2>&1
    """
}
