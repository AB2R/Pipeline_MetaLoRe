process filt_blast_mobileog {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/3-filtration_blast/2-filt_blast_mobileog",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/filt_blast_mobileog",     mode: 'copy', pattern: 'filt_blast_mobileog.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'filt_blast_mobileog.cmd'

    // Workflow input stream
    input:
        each(mobileog_ch)

    // Workflow output stream
    output:
        path("*.tab"), emit: filt_mobileog_ch
        // we also collect commands executed and log files
        path("filt_blast_mobileog.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/filt_blast_mobileog.py -i ${mobileog_ch} &> filt_blast_mobileog.log 2>&1
    """
}
