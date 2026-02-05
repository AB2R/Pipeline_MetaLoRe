process easynanometa {

    label 'highmem'

    tag { easynanometa }

    publishDir "${params.outdir}/easynanometa/${sample_id}",
               mode: 'copy'

    input:
    tuple val(sample_id), path(fastq_dir)

    output:
    tuple val(sample_id), path("easynanometa_result")

    script:
    """
    python easynanometa.py \
        -f ${fastq_dir} \
        -t ${task.cpus} \
        -host-removal-reference ${params.host_ref} \
        -kraken2-db ${params.kraken2_db} \
        -centrifuge-db ${params.centrifuge_db} \
	-checkm2 ${params.checkm2}
    """
}
