process filt_blast_plasmidf {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/3-filtration_blast/3-filt_blast_plasmidf",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/filt_blast_plasmidf",     mode: 'copy', pattern: 'filt_blast_plasmidf.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'filt_blast_plasmidf.cmd'

    // Workflow input stream
    input:
        each(plasmidf_ch)

    // Workflow output stream
    output:
        path("*.tab"), emit: filt_plasmidf_ch
        // we also collect commands executed and log files
        path("filt_blast_plasmidf.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/filt_blast_plasmidf.py -i ${plasmidf_ch} &> filt_blast_plasmidf.log 2>&1
    """
}
