#! /usr/bin/Rscript

library(tximport)
library(readr)
library(stringr)

# Rscript tximport_R.R gencode.vM19.metadata.MGI.gz Illumina_PE_SRR.csv output.tsv

SRRs <- c("SRR10738313", "SRR10738318", "SRR10738253", "SRR10738254")

tx2knownGene <- read_delim("gencode.v37.metadata.HGNC.gz", '\t', col_names = c('TXNAME', 'GENEID'))

# print(paste(c("salmon_output_") , split.vec, c("/quant.sf"), sep=''))

# files <- paste(c("salmon_output_") , exp.table[,2], c("/quant.sf"), sep='')
files <- paste(c("salmon_output_") , SRRs, c("/quant.sf"), sep='')
names(files) <- SRRs

print(files)

# txi.salmon <- tximport(files, type = "salmon", tx2gene = tx2knownGene)
txi.salmon <- tximport(files, type = "salmon", tx2gene = tx2knownGene, 
                        countsFromAbundance="scaledTPM")

write.table(txi.salmon$counts, file="output_salmon_scaledTPM.tsv", 
            sep="\t", col.names=NA, row.names=T, quote=F, append=F)