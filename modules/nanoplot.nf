process nanoplot {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'
    
    // not necessary to include tag section 
    
    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/1-qc/1-nanoplot",	mode: 'copy', pattern: 'nano_*'
    publishDir "${params.resultdir}/logs/nanoplot",	mode: 'copy', pattern: 'nanoplot.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd",	mode: 'copy', pattern: 'nanoplot.cmd'
    
    // Workflow input stream
    input:
        path(ONT_data)

    // Workflow output stream
    output:
        path("nano_*")
        // we also collect commands executed and log files
        path("nanoplot.log")
        path("nanoplot.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    nanoplot.sh ${ONT_data} ${task.cpus} nanoplot.cmd &> nanoplot.log 2>&1
    """ 
}
