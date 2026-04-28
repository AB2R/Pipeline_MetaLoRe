process cooccurrences_reads {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/4-cooccurrences",   mode: 'copy', pattern: 'cooccurrences_reads.tab'
    publishDir "${params.resultdir}/logs/cooccurrences",     mode: 'copy', pattern: 'cooccurrences.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'cooccurrences.cmd'

    // Workflow input stream
    input:
        path(filt_reads_megares_ch)
        path(filt_reads_mobileOG_ch)
        path(reads_plasmidf_ch)
	path(ab_ncbi_ch)
	path(ab_card_ch)
	path(ab_resfinder_ch)
	path(ab_megares_ch)
	path(ab_plasmidf_ch)
    // Workflow output stream
    output:
        path("cooccurrences_reads.tab")
        // we also collect commands executed and log files
        path("cooccurrences.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/cooccurrences_reads.py --blast ${filt_reads_megares_ch} ${filt_reads_mobileOG_ch} ${reads_plasmidf_ch} --abricate ${ab_ncbi_ch} ${ab_card_ch} ${ab_resfinder_ch} ${ab_megares_ch} ${ab_plasmidf_ch} &> cooccurrences.log 2>&1
    """
}
