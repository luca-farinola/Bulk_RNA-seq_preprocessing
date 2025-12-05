nextflow.enable.dsl=2

include { FASTQC     } from './modules/fastqc.nf'
include { TRIM_GALORE } from './modules/trim.nf'
include { STAR_ALIGN } from './modules/star_align.nf'
include { QUANT } from './modules/quant.nf'
include { MULTIQC } from './modules/multiqc.nf'

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
    index_ch = Channel.value( file(params.indexforstar) )
    STAR_ALIGN( samples_ch, index_ch )

    // Quantification with featureCounts
    quant_ch = Channel.value( file(params.gtf_file) )
    QUANT( STAR_ALIGN.out.bam.collect(), quant_ch )

    MULTIQC( FASTQC.out.zip.collect() )
}

// MAMBA FORGE 