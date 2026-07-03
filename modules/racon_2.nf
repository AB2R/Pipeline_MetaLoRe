process racon_2 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-assembly_alignment_polishing/5-racon_2",   mode: 'copy', pattern: '*racon2.fasta'
    publishDir "${params.resultdir}/logs/racon_2",     mode: 'copy', pattern: 'racon_2.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'racon_2.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(id2_ch), path(aln3_ch), path(polish1_ch)
    // Workflow output stream
    output:
        tuple val(sample_id), path("*racon2.fasta"), emit: polish2_ch
        // we also collect commands executed and log files
        path("racon_2.log")
        path("racon_2.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    racon_2.sh ${id2_ch} ${aln3_ch} ${polish1_ch} ${task.cpus} racon_2.cmd &> racon_2.log 2>&1
    """
}
