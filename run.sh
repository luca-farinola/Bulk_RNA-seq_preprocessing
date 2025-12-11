
nextflow run main.nf \
  --samplesheet /home/luca/expatstorage/neutropenic_omics/NGS_Liver/NGS_224_923/samplesheet.csv \
  --indexforstar /home/luca/expatstorage/reference_annotations/ngs_indices/STAR/GRCm39/star_index \
  --gtf_file /home/luca/expatstorage/reference_annotations/ngs_indices/STAR/GRCm39/Mus_musculus.GRCm39.115.gtf \
  -profile docker -resume

