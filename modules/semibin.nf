process semibin {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'midmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/4-binning/1-semibin",   mode: 'copy', pattern: '*semibin_out/**'
    publishDir "${params.resultdir}/logs/semibin",     mode: 'copy', pattern: 'semibin.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'semibin.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(polish3_ch), path(bam2_ch)
    // Workflow output stream
    output:
        tuple val(sample_id), path("${sample_id}_semibin_out/output_bins"), emit: bins_dir_ch
	tuple val(sample_id), path("${sample_id}_semibin_out/output_bins/*.fa.gz"), emit: bins_files_ch
        // we also collect commands executed and log files
        path("semibin.log")
        path("semibin.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    semibin.sh ${polish3_ch} ${bam2_ch} ${sample_id}_semibin_out ${task.cpus} ${params.env_semibin} semibin.cmd &> semibin.log 2>&1
    """
}
