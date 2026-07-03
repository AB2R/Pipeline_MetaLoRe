process seqkit {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/2-trimming_filtering/5-seqkit",   mode: 'copy', pattern: '*.fasta'
    publishDir "${params.resultdir}/logs/seqkit",     mode: 'copy', pattern: 'seqkit.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'seqkit.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(id_ch), path(filt_ch)
    // Workflow output stream
    output:
        tuple val(sample_id), path("*.fasta"), emit: id2_ch
        // we also collect commands executed and log files
        path("seqkit.log")
        path("seqkit.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    seqkit.sh ${id_ch} ${filt_ch} seqkit.cmd &> seqkit.log 2>&1
    """
}
