process filt_blast_megares {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/3-filtration_blast/1-filt_blast_megares",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/filt_blast_megares",     mode: 'copy', pattern: 'filt_blast_megares.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'filt_blast_megares.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(megares_ch)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*.tab"), emit: filt_megares_ch
        // we also collect commands executed and log files
        path("filt_blast_megares.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/filt_blast_megares.py -i ${megares_ch} &> filt_blast_megares.log 2>&1
    """
}
