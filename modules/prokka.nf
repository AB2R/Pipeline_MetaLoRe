process prokka {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'lowmem'
    maxForks 1

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/9-annotation/2-prokka",   mode: 'copy', pattern: '*.faa'
    publishDir "${params.resultdir}/9-annotation/2-prokka",   mode: 'copy', pattern: '*.fna'
    publishDir "${params.resultdir}/9-annotation/2-prokka",   mode: 'copy', pattern: '*.gff'
    publishDir "${params.resultdir}/logs/prokka",     mode: 'copy', pattern: 'prokka.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'prokka.cmd'

    // Workflow input stream
    input:
        each(bins_files_ch)

    // Workflow output stream
    output:
        path("prokka_out/*/*.faa")
        path("prokka_out/*/*.fna")
        path("prokka_out/*/*.gff")
        // we also collect commands executed and log files
        path("prokka.log")
        path("prokka.cmd")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    prokka.sh prokka_out ${bins_files_ch} prokka.cmd &> prokka.log 2>&1
    """
}
