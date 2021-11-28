#!/bin/bash

<< COMMENTOUT
fasterq-dump xxx
trim galore (遅いですが、ikraとoutputを合わせるため)
salmon index
salmon quant
tximport?
STAR -> igv (間に合わないから紹介だけ?)
ikra (紹介だけ)
COMMENTOUT

# 必要ファイルのダウンロード
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_37/gencode.v37.pc_transcripts.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_37/gencode.v37.metadata.HGNC.gz

# fasterq-dump
fasterq-dump SRR10738313 --split-files --threads 4 -p
fasterq-dump SRR10738318 --split-files --threads 4 -p
fasterq-dump SRR10738253 --split-files --threads 4 -p
fasterq-dump SRR10738254 --split-files --threads 4 -p

# 圧縮 pigzでも
gzip SRR_*.gz

# trim-galore
trim_galore --cores 4 --paired SRR10738313_1.fastq.gz SRR10738313_2.fastq.gz
trim_galore --cores 4 --paired SRR10738318_1.fastq.gz SRR10738318_2.fastq.gz
trim_galore --cores 4 --paired SRR10738253_1.fastq.gz SRR10738253_2.fastq.gz
trim_galore --cores 4 --paired SRR10738254_1.fastq.gz SRR10738254_2.fastq.gz

# salmon index
salmon index --threads 4 --transcripts gencode.v37.pc_transcripts.fa.gz \
    --index salmon_index -k 31 --gencode

# salmon quant
salmon quant -i salmon_index \
      -l A \
      -1 SRR10738313_1_val_1.fq.gz \
      -2 SRR10738313_2_val_2.fq.gz \
      -p 4 \
      -o salmon_output_SRR10738313 \
      --gcBias \
      --validateMappings

salmon quant -i salmon_index \
      -l A \
      -1 SRR10738318_1_val_1.fq.gz \
      -2 SRR10738318_2_val_2.fq.gz \
      -p 4 \
      -o salmon_output_SRR10738318 \
      --gcBias \
      --validateMappings

salmon quant -i salmon_index \
      -l A \
      -1 SRR10738253_1_val_1.fq.gz \
      -2 SRR10738253_2_val_2.fq.gz \
      -p 4 \
      -o salmon_output_SRR10738253 \
      --gcBias \
      --validateMappings

salmon quant -i salmon_index \
      -l A \
      -1 SRR10738254_1_val_1.fq.gz \
      -2 SRR10738254_2_val_2.fq.gz \
      -p 4 \
      -o salmon_output_SRR10738254 \
      --gcBias \
      --validateMappings

# tximport 
Rscript tximport.R

# STAR index （説明のみ）
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_37/GRCh38.primary_assembly.genome.fa.gz
gunzip GRCh38.primary_assembly.genome.fa.gz
STAR \
    --runMode genomeGenerate \
    --genomeDir STAR_index \
    --runThreadN 4 \
    --genomeFastaFiles GRCh38.primary_assembly.genome.fa

# STAR align （説明のみ） + index
for SRR in SRR10738313 SRR10738318 SRR10738253 SRR10738254; do
    STAR \
    --genomeDir STAR_index \
    --runThreadN 4 \
    --outFileNamePrefix ${SRR}_ \
    --outSAMtype BAM SortedByCoordinate \
    --readFilesIn ${SRR}_1_val_1.fq.gz ${SRR}_2_val_2.fq.gz \
    --readFilesCommand gunzip -c
    
    samtools index ${SRR}_Aligned.sortedByCoord.out.bam
done

# ikra
# git clone https://github.com/yyoshiaki/ikra.git
# ikra/ikra.sh design.csv human --protein-coding --threads 4 --align star --gencode 37