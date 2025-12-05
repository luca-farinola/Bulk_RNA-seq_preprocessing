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

    // QC on trimmed Files with MultiQC
    MULTIQC( FASTQC.out.zip.collect() )

    if( params.onlyqc ) {
        log.info "\n[INFO] onlyqc flag is set — stopping after FASTQC + MULTIQC.\n"
        return
    }

    // if adapter trimming
        if( params.trim ) {
        log.info "\n[INFO] trim flag is set — performing adapter trimming.\n"
        TRIM_GALORE( samples_ch )
        reads_for_alignment = TRIM_GALORE.out.trimmed_reads
    }
    else {
        log.info "\n[INFO] No trimming — using raw reads for alignment.\n"
        reads_for_alignment = samples_ch
    }

    // STAR: align each sample (paired-end)
    index_ch = Channel.value( file(params.indexforstar) )
    STAR_ALIGN( reads_for_alignment, index_ch )

    // Quantification with featureCounts
    quant_ch = Channel.value( file(params.gtf_file) )
    QUANT( STAR_ALIGN.out.bam.collect(), quant_ch )
}

// MAMBA FORGE 