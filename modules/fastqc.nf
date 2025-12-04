nextflow.enable.dsl=2

process FASTQC {

    tag "${sample_id}"

    publishDir params.outdir_fastqc, mode: 'copy'

    input:
        tuple val(sample_id), path(read1), path(read2)

    output:
        path "*_fastqc.zip",  emit: zip
        path "*_fastqc.html", emit: html

    script:
    """
    fastqc ${read1} ${read2}  
    """

    //mkdir -p /tmp/fastqctemporary, --outdir /tmp/fastqctemporary ? 
}