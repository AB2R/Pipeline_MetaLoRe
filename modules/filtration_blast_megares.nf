process filtration_blast_megares {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/10-filtered_results/1-filtration_blast_megares",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/filtration_blast_megares",     mode: 'copy', pattern: 'filtration_blast_megares.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'filtration_blast_megares.cmd'

    // Workflow input stream
    input:
        each(megares_ch)

    // Workflow output stream
    output:
        path("*.tab"), emit: filt_megares_ch
        // we also collect commands executed and log files
        path("filtration_blast_megares.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/filtration_blast_megares.py -i ${megares_ch} &> filtration_blast_megares.log 2>&1
    """
}
