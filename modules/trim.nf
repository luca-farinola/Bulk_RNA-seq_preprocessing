nextflow.enable.dsl=2

process TRIM_GALORE {

    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"
    publishDir params.outdir_trim, mode: 'copy'

    label 'trim'

    errorStrategy 'finish'

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    tuple val(sample_id), path("*_val_1.fq.gz"), path("*_val_2.fq.gz"), emit: trimmed_reads
    path "*_trimming_report.txt", emit: trimming_reports

    script:
    """
    trim_galore --fastqc --paired ${read1} ${read2}
    """
}