process filt_reads_blast_mobileOG {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/3-filtration_blast/2-filt_reads_blast_mobileOG",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/filt_reads_blast_mobileOG",     mode: 'copy', pattern: 'filt_reads_blast_mobileOG.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'filt_reads_blast_mobileOG.cmd'

    // Workflow input stream
    input:
        each(reads_mobileOG_ch)

    // Workflow output stream
    output:
        path("*.tab"), emit: filt_reads_mobileOG_ch
        // we also collect commands executed and log files
        path("filt_reads_blast_mobileOG.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/filt_reads_blast_mobileOG.py -i ${reads_mobileOG_ch} &> filt_reads_blast_mobileOG.log 2>&1
    """
}
