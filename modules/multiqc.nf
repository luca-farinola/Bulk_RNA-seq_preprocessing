nextflow.enable.dsl=2

process MULTIQC {

    container "community.wave.seqera.io/library/multiqc:1.32--d58f60e4deb769bf"
    publishDir params.outdir_multiqc, mode: 'rellink'
    
    label 'multiqc'

    errorStrategy 'finish'

    input:
    path fastqc_files
            
    output:
    path "*multiqc_report.html"
    path "*_data" 
    
    script: 
    """
    multiqc .

    """     
}