nextflow.enable.dsl=2

process FASTQC {

    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"
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