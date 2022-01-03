FROM conda/miniconda3:latest

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*
  
RUN conda install -c conda-forge -c bioconda -y trim-galore==0.6.7 \
        salmon==1.6.0 bioconductor-tximport==1.22.0 sra-tools==2.11.0 \
        star==2.7.9a samtools==1.14 pigz==2.6

# RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.11.3/sratoolkit.2.11.3-ubuntu64.tar.gz \
#     && tar -xvf sratoolkit.2.11.3-ubuntu64.tar.gz \
#     && rm sratoolkit.2.11.3-ubuntu64.tar.gz

RUN Rscript -e 'install.packages("tidyverse", dependencies=TRUE, repos = "https://cran.ism.ac.jp/")'
