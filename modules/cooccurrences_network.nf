process cooccurrences_network {

    // label is used to find appropriate resources to use with this task.
    // see conf/resources.conf
    label 'ultralowmem'

    // not necessary to include tag section

    // Result files published in Netxtflow result directory.
    // See also 'output' directive, below.
    publishDir "${params.resultdir}/8-genes_research/4-cooccurrences/3-cooccurrences_network",   mode: 'copy', pattern: '*.png'
    publishDir "${params.resultdir}/logs/cooccurrences_network",     mode: 'copy', pattern: 'cooccurrences_network.log'
    publishDir "${params.outdir}/00_pipeline_info/cmd", mode: 'copy', pattern: 'cooccurrences_network.cmd'

    // Workflow input stream
    input:
        tuple path(edges_ch), path(nodes_ch)
    // Workflow output stream
    output:
        path("*.png")
        // we also collect commands executed and log files
        path("cooccurrences_network.log")

    // Script to execute (located in bin/ sub-directory)
    script:
    """
    #!/bin/bash -l
    . /local/env/envpython-3.11.9.sh
    set -euxo pipefail
    python ${baseDir}/bin/cooccurrences_network.py --edges ${edges_ch} --nodes ${nodes_ch} > cooccurrences_network.log 2>&1
    """
}
