#!/usr/bin/env nextflow

process QUANT {

    container "community.wave.seqera.io/library/subread:2.1.1--0ac4d7e46cd0c5d7"
    publishDir params.outdir_quant, mode: 'copy'

    input:
    path bam_files
    path gtf_file

    output:
    path "featureCounts.txt", emit: counts

    script:
    """
    featureCounts -p -a ${gtf_file} -o featureCounts.txt ${bam_files}
    """
}