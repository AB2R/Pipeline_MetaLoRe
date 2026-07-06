process cooccurrences_research {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/4-cooccurrences/1-cooccurrences_research",   mode: 'copy', pattern: '*.tsv'
    publishDir "${params.resultdir}/logs/cooccurrences_research",     mode: 'copy', pattern: 'cooccurrences_research.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'cooccurrences_research.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(filt_megares_ch), path(filt_mobileog_ch), path(filt_plasmidf_ch), path(ab_card_ch), path(ab_resfinder_ch), path(ab_ncbi_ch), path(prot_ch)
	path(params.mobileog_metadata)
	val(params.genomic_dist)
    // Workflow output stream
    output:
        tuple val(sample_id), path("*_cooccurrences.tsv"), emit: coocc_ch
	tuple val(sample_id), path("*_cooccurrences_summary.tsv"), emit: coocc_sum_ch
        // we also collect commands executed and log files
        path("cooccurrences_research.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
     python ${baseDir}/bin/cooccurrences_research.py --blast_megares ${filt_megares_ch} --blast_mobileog ${filt_mobileog_ch} --blast_plasmidfinder ${filt_plasmidf_ch} --abr_card ${ab_card_ch} --abr_resfinder ${ab_resfinder_ch} --abr_ncbiamr ${ab_ncbi_ch} --gbk ${prot_ch} --mobileog_db ${params.mobileog_metadata} --max_distance ${params.genomic_dist} --output \$(basename ${filt_megares_ch}) &> cooccurrences_research.log 2>&1
    """
}
