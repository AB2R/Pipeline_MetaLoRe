process porechop_abi {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'
    
    // not necessary to include tag section 
    
    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/2-trimming_filtering/1-porechop_abi",	mode: 'copy', pattern: '*.fastq'
    publishDir "${params.resultdir}/logs/porechop_abi",	mode: 'copy', pattern: 'porechop_abi.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd",	mode: 'copy', pattern: 'porechop_abi.cmd'
    
    // Workflow input stream
    input:
        path(cleanfq_ch)

    // Workflow output stream
    output:
        path("*.fastq"), emit: trim_ch
        // we also collect commands executed and log files
        path("porechop_abi.log")
        path("porechop_abi.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    porechop_abi.sh ${task.cpus} ${cleanfq_ch} porechop_abi.cmd &> porechop_abi.log 2>&1
    """ 
}

