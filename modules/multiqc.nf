process multiqc {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'
    
    // not necessary to include tag section 
    
    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/1-qc/4-multiqc",   mode: 'copy', pattern: '*.html'
    publishDir "${params.resultdir}/logs/multiqc",     mode: 'copy', pattern: 'multiqc.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'multiqc.cmd'
    
    // Workflow input stream
    input:
        path(results_ch)

    // Workflow output stream
    output:
        path("*.html")
        // we also collect commands executed and log files
        path("multiqc.log")
        path("multiqc.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    multiqc.sh ${results_ch} multiqc.cmd &> multiqc.log 2>&1
    """ 
}
