process medaka {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-assembly_alignment_polishing/8-medaka",   mode: 'copy', pattern: 'medaka_out/*.fasta'
    publishDir "${params.resultdir}/logs/medaka",     mode: 'copy', pattern: 'medaka.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'medaka.cmd'

    // Workflow input stream
    input:
        path(bam2_ch)
        path(polish2_ch)

    // Workflow output stream
    output:
        path("medaka_out/*.fasta"), emit: polish3_ch
        // we also collect commands executed and log files
        path("medaka.log")
        path("medaka.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    medaka.sh ${bam2_ch} ${polish2_ch} ${task.cpus} medaka_out ${params.model_medaka} medaka.cmd &> medaka.log 2>&1
    """
}
