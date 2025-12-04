nextflow.enable.dsl=2

include { FASTQC     } from './modules/fastqc.nf'
include { TRIM_GALORE } from './modules/trim.nf'
include { STAR_ALIGN } from './modules/star_align.nf'
include { QUANT } from './modules/quant.nf'

workflow {

    // Channel of rows from samplesheet (maps)
    samples_ch = Channel
        .fromPath( params.samplesheet )
        .splitCsv(header: true)

    // FastQC: you already have this working using the same `val row` pattern
    FASTQC( samples_ch )

    // if adapter trimming
    TRIM_GALORE( samples_ch )

    // STAR: align each sample (paired-end)
    STAR_ALIGN( samples_ch, params.indexforstar )

    // Quantification with featureCounts
    QUANT( STAR_ALIGN.out.bam.collect(), params.gtf_file )
}

// MAMBA FORGE 