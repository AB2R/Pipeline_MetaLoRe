process gtdbtk {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'highmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/7-taxonomy/3-gtdbtk",   mode: 'copy', pattern: 'gtdbtk_out/**'
    publishDir "${params.resultdir}/logs/gtdbtk",     mode: 'copy', pattern: 'gtdbtk.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'gtdbtk.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(bins_flat_ch)

    // Workflow output stream
    output:
        tuple val(sample_id), path("gtdbtk_out/**"), emit: gtdbtk_ch
        // we also collect commands executed and log files
        path("gtdbtk.log")
        path("gtdbtk.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    gtdbtk.sh ${bins_flat_ch} gtdbtk_out ${task.cpus} gtdbtk.cmd &> gtdbtk.log 2>&1
    """
}
