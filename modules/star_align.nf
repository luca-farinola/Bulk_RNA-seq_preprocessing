nextflow.enable.dsl=2

process STAR_ALIGN {

    container "community.wave.seqera.io/library/star:2.7.11b--822039d47adf19a7"
    publishDir params.outdir_star, mode: 'copy'

    input:
        tuple val(sample_id), path(read1), path(read2)
        path indexforstar


    // 40 GB , 16 cpu 

    output:
        path "${sample_id}*.out.bam", emit: bam
        path "${sample_id}.Log.final.out", emit: log
        path "${sample_id}.SJ.out.tab", emit: sj

    script:
    """
    STAR \\
      --genomeDir ${indexforstar} \\
      --readFilesIn  ${read1} ${read2}  \\
      --readFilesCommand zcat \\
      --outSAMtype BAM Unsorted \\
      --outFileNamePrefix ${sample_id}.
    """
}