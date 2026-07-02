process flye {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'highmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/3-assembly_alignment_polishing/1-flye",   mode: 'copy', pattern: '*_flye_out/assembly.fasta'
    publishDir "${params.resultdir}/logs/flye",     mode: 'copy', pattern: 'flye.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'flye.cmd'

    // Workflow input stream
    input:
        path(id2_ch)

    // Workflow output stream
    output:
        path("*_flye_out/assembly.fasta"), emit: asmbl_ch
        // we also collect commands executed and log files
        path("flye.log")
        path("flye.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    flye.sh ${id2_ch} \$(basename \${id2_ch%%_*})_flye_out ${task.cpus} flye.cmd &> flye.log 2>&1
    """
}
