nextflow.enable.dsl=2

process STAR_ALIGN {

    tag "${sample_id}"
    
    publishDir params.outdir_star, mode: 'copy'

    /*
     * We reuse the same row map as for FASTQC:
     * row.sample_id, row.fastq_1, row.fastq_2
     * Since you’re running locally, we can pass the host paths directly.
     */

    input:
        tuple val(sample_id), path(read1), path(read2)

    output:
        path "${sample_id}.Aligned.sortedByCoord.out.bam", emit: bam
        path "${sample_id}.Log.final.out",                 emit: log
        path "${sample_id}.SJ.out.tab",                    emit: sj

    script:
    """
    STAR \\
      --genomeDir ${params.indexforstar} \\
      --readFilesIn  ${read1} ${read2}  \\
      --readFilesCommand zcat \\
      --outSAMtype BAM SortedByCoordinate \\
      --outFileNamePrefix ${sample_id}.
    """
}