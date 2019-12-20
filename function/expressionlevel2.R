
expressionlevel2 <- function(filepath, path) {
  
sampleID <- c(list.files(filepath))
gencode <- read.csv2(paste0(path, 'gencode_final.csv'), stringsAsFactors = FALSE)[,-1]
topgene <- read.csv(paste0(path, 'topgene.csv'), sep = ';')
midgene <- read.csv(paste0(path, 'midgene.csv'), sep = ';')    
bottomgene <- read.csv(paste0(path, 'bottomgene.csv'), sep = ';')    

file_strand <- read.csv2(paste0(path,'strandspecificity.csv'), stringsAsFactors = FALSE)

samples <- vector()
x=0
for (sample in sampleID){   
    samples <- c(samples, sample) 
    file <- read.table(paste0(filepath, sample, '/tumor/paired/merged-alignment/featureCounts/', 
                     'tumor_', sample,'.fpkm_tpm.featureCounts.tsv'), header=TRUE, comment.char='', stringsAsFactors = FALSE)
    file <- file[file[,'X.chrom'] %in% c(1:22, 'X','Y'),]
    # add gene type and transcript type to the file
    file_gencode <- left_join(file, gencode, by = 'gene_id') 

    if (mean(as.numeric(file_strand[,'all.end1PercentageSense'])) < 95 | mean(as.numeric(file_strand[,'all.end1PercentageSense'])) < 95) {
         a <- 'TPM' 
      } else if (mean(file[,'TPM_fw']) > mean(file[,'TPM_rv'])) {
            a <- 'TPM_fw'
         } else { a <- 'TPM_rv' 
           }

    topgene_exp <- file_gencode[file_gencode[,'gene_id'] %in% topgene[,'gene'], a]
    midgene_exp <- file_gencode[file_gencode[,'gene_id'] %in% midgene[,'gene'], a]
    bottomgene_exp <- file_gencode[file_gencode[,'gene_id'] %in% bottomgene[,'gene'], a]

    if (x==0) {
    topgene1 <- file_gencode[file_gencode[,'gene_id'] %in% topgene[,'gene'], 'gene_id']
    midgene1 <- file_gencode[file_gencode[,'gene_id'] %in% midgene[,'gene'], 'gene_id']
    bottomgene1 <- file_gencode[file_gencode[,'gene_id'] %in% bottomgene[,'gene'], 'gene_id']
    topgene_df <- data.frame(topgene1)
    midgene_df <- data.frame(midgene1)
    bottomgene_df <- data.frame(bottomgene1)
    }

    topgene_df <- cbind(topgene_df, topgene_exp)
    midgene_df <- cbind(midgene_df, midgene_exp)
    bottomgene_df <- cbind(bottomgene_df, bottomgene_exp)
    x=x+1
}

colnames(topgene_df) <- c('gene',samples)
colnames(midgene_df) <- c('gene',samples) 
colnames(bottomgene_df) <- c('gene',samples)

write.csv(topgene_df, paste0(path, 'topgene_exp.csv'))
write.csv(midgene_df, paste0(path, 'midgene_exp.csv'))
write.csv(bottomgene_df, paste0(path,'bottomgene_exp.csv'))

}
