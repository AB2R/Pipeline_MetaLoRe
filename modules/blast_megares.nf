process blast_megares {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/9-annotation/6-blast_megares",   mode: 'copy', pattern: '*.tab'
    publishDir "${params.resultdir}/logs/blast_megares",     mode: 'copy', pattern: 'blast_megares.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'blast_megares.cmd'

    // Workflow input stream
    input:
        each(bins_files_ch)
	path(params.megares_db)

    // Workflow output stream
    output:
        path("*.tab")
        // we also collect commands executed and log files
        path("blast_megares.log")
        path("blast_megares.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    blast_megares.sh ${bins_files_ch} ${params.megares_db} blast_megares.cmd &> blast_megares.log 2>&1
    """
}
