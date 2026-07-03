process prodigal {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/5-annotation/1-prodigal",   mode: 'copy', pattern: '*.faa'
    publishDir "${params.resultdir}/5-annotation/1-prodigal",   mode: 'copy', pattern: '*.fna'
    publishDir "${params.resultdir}/5-annotation/1-prodigal",   mode: 'copy', pattern: '*.gbk'
    publishDir "${params.resultdir}/logs/prodigal",     mode: 'copy', pattern: 'prodigal.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'prodigal.cmd'

    // Workflow input stream
    input:
        tuple val(sample_id), path(polish3_ch)

    // Workflow output stream
    output:
        tuple val(sample_id), path("*.faa"), emit: prot_ch
        tuple val(sample_id), path("*.fna"), emit: genes_ch
        tuple val(sample_id), path("*.gbk"), emit: gbk_ch
        // we also collect commands executed and log files
        path("prodigal.log")
        path("prodigal.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    prodigal.sh ${polish3_ch} prodigal.cmd &> prodigal.log 2>&1
    """
}
