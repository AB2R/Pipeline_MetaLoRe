process kraken2_asmbl {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'krakenmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/7-taxonomy/3-kraken2_asmbl",   mode: 'copy', pattern: '*.kraken'
    publishDir "${params.resultdir}/7-taxonomy/3-kraken2_asmbl",   mode: 'copy', pattern: '*.report'
    publishDir "${params.resultdir}/logs/kraken2_asmbl",     mode: 'copy', pattern: 'kraken2_asmbl.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'kraken2_asmbl.cmd'

    // Workflow input stream
    input:
        path(medaka_ch)

    // Workflow output stream
    output:
        path("*.kraken")
        path("*.report")
        // we also collect commands executed and log files
        path("kraken2_asmbl.log")
        path("kraken2_asmbl.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    kraken2_asmbl.sh ${task.cpus} ${params.db_kraken} ${medaka_ch} kraken2_asmbl.cmd &> kraken2_asmbl.log 2>&1
    """
}
