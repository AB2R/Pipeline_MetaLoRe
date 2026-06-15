process genes_research {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/4-cooccurrences_research",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/cooccurrences_research",     mode: 'copy', pattern: 'cooccurrences_research.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'cooccurrences_research.cmd'

    // Workflow input stream
    input:
        path(filt_megares_ch)
	path(filt_mobileog_ch)
	path(filt_plasmidf_ch)
	path(ab_card_ch)
	path(ab_resfinder_ch)
	path(ab_ncbi_ch)
	path(prot_ch)
	path(params.mobileog_metadata)
    // Workflow output stream
    output:
        path("*.tab")
        // we also collect commands executed and log files
        path("cooccurrences_research.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
     python ${baseDir}/bin/genes_research.py ${filt_megares_ch} ${filt_mobileog_ch} ${filt_plasmidf_ch} ${ab_card_ch} ${ab_resfinfer_ch} ${ab_ncbi_ch} ${prot_ch} ${params.mobileog_metadata} &> abricate.log 2>&1
    """
}
