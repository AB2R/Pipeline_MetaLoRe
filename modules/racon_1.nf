process racon_1 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-assembly_alignment_polishing/3-racon_1",   mode: 'copy', pattern: '*racon.fasta'
    publishDir "${params.resultdir}/logs/racon_1",     mode: 'copy', pattern: 'racon_1.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'racon_1.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(id2_ch), path(aln2_ch), path(asmbl_ch)
    // Workflow output stream
    output:
        tuple val(sample_id), path("*racon.fasta"), emit: polish1_ch
        // we also collect commands executed and log files
        path("racon_1.log")
        path("racon_1.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    racon_1.sh ${id2_ch} ${aln2_ch} ${asmbl_ch} ${task.cpus} racon_1.cmd &> racon_1.log 2>&1
    """
}
