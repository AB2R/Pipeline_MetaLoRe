process cooccurrences_files {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/5-cooccurrences_files",   mode: 'copy', pattern: '*.csv'
    publishDir "${params.resultdir}/logs/cooccurrences_files",     mode: 'copy', pattern: 'cooccurrences_files.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'cooccurrences_files.cmd'

    // Workflow input stream
    input:
        tuple path(coocc_ch), path(coocc_sum_ch), path(gcpm_ch)
    // Workflow output stream
    output:
        path("edges.csv"), emit: edges_ch
	path("nodes.csv"), emit: nodes_ch
        // we also collect commands executed and log files
        path("cooccurrences_files.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
     python ${baseDir}/bin/cooccurrences_files.py --coocc ${coocc_ch} --summary ${coocc_sum_ch} --gcpm ${gcpm_ch} &> cooccurrences_files.log 2>&1
    """
}
