process nanoplot {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'
    
    // not necessary to include tag section 
    
    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/1-qc/1-nanoplot",	mode: 'copy', pattern: '*_nanoqc*'
    publishDir "${params.resultdir}/logs/nanoplot",	mode: 'copy', pattern: 'nanoplot.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd",	mode: 'copy', pattern: 'nanoplot.cmd'
    
    // Workflow input stream
    input:
        tuple val(sample_id), path(ONT_ch)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*_nanoqc*"), emit: nanoqc_ch
        // we also collect commands executed and log files
        path("nanoplot.log")
        path("nanoplot.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    nanoplot.sh ${ONT_ch} ${task.cpus} nanoplot.cmd &> nanoplot.log 2>&1
    """ 
}
