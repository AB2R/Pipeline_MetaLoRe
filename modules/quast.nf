process quast {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/1-qc/2-quast",   mode: 'copy', pattern: 'quast_out'
    publishDir "${params.resultdir}/logs/quast",     mode: 'copy', pattern: 'quast.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'quast.cmd'

    // Workflow input stream
    input:
	path(asmbl_ch)
	path(polish2_ch)
        path(polish3_ch)

    // Workflow output stream
    output:
        path("quast_out")
        // we also collect commands executed and log files
        path("quast.log")
        path("quast.cmd")

    // Script to execute (located in bin/ sub-directory)
    script: 
    """
    quast.sh ${asmbl_ch} ${polish2_ch} ${polish3_ch} ${task.cpus} quast_out quast.cmd &> quast.log 2>&1
    """
}
