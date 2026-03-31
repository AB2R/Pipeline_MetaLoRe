process collect_read_id {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/2-trimming_filtering/3-collect_read_id",   mode: 'copy', pattern: '*.txt'
    publishDir "${params.resultdir}/logs/collect_read_id",     mode: 'copy', pattern: 'collect_read_id.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'collect_read_id.cmd'

    // Workflow input stream
    input:
        path(kraken_ch)

    // Workflow output stream
    output:
        path("*.txt"), emit: id_ch
        // we also collect commands executed and log files
        path("collect_read_id.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    python ${baseDir}/bin/collect_read_id.py -i ${kraken_ch} -d ${params.db_kraken} -o read_id.txt &> collect_read_id.log 2>&1
    """
}
