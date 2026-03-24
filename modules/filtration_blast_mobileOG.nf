process filtration_blast_mobileOG {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/10-filtered_results/2-filtration_blast_mobileOG",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/filtration_blast_mobileOG",     mode: 'copy', pattern: 'filtration_blast_mobileOG.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'filtration_blast_mobileOG.cmd'

    // Workflow input stream
    input:
        each(mobileOG_ch)

    // Workflow output stream
    output:
        path("*.tab"), emit: filt_mobileOG_ch
        // we also collect commands executed and log files
        path("filtration_blast_mobileOG.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/filtration_blast_mobileOG.py -i ${mobileOG_ch} &> filtration_blast_mobileOG.log 2>&1
    """
}
