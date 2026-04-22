process kraken2 {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'krakenmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/6-taxonomy/1-kraken2",   mode: 'copy', pattern: '*.kraken'
    publishDir "${params.resultdir}/6-taxonomy/1-kraken2",   mode: 'copy', pattern: '*.report'
    publishDir "${params.resultdir}/logs/kraken2",     mode: 'copy', pattern: 'kraken2.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'kraken2.cmd'

    // Workflow input stream
    input:
        path(filt_ch)

    // Workflow output stream
    output:
        path("*.kraken"), emit: kraken_ch
	path("*.report"), emit: kraken_report_ch
        // we also collect commands executed and log files
        path("kraken2.log")
        path("kraken2.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    kraken2.sh ${task.cpus} ${params.db_kraken} ${filt_ch} kraken2.cmd &> kraken2.log 2>&1
    """
}
