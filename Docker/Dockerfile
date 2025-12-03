FROM continuumio/miniconda3:25.3.1-1

# Create a dedicated environment for rnaseq tools
RUN conda update -n base -c defaults conda

# Create environment and install STAR
RUN conda install bioconda::star

