library(dplyr)

expressionlevel1 <- function(filepath, path) {

sampleID <- c(list.files(filepath))

et_scriptdir = function() {
  args = commandArgs()
  f = grep("^--file=", args, value = TRUE)
  if(length(f)) {
    f = gsub("^--file=(.*)$", "\\1", f[1])
    return(dirname(normalizePath(f))) 
  } else {
    return(NULL)
  }
}

toolpath <- get_scriptdir()

gencode <- read.csv2(paste0(toolpath, '/gencode_final.csv'), stringsAsFactors = FALSE)[,-1]

file_strand <- read.csv2(paste0(path, 'strandspecificity.csv'), stringsAsFactors = FALSE)

genetype <- c('protein_coding', 'Mt_rRNA', 'Mt_tRNA', 'miRNA', 'misc_RNA', 'rRNA', 'scRNA', 'snRNA', 'snoRNA',
              'ribozyme', 'sRNA', 'scaRNAc', 'lincRNA', 'macro_lncRNA', '3prime_overlapping_ncRNA', 'vaultRNA', 
              'bidirectional_promoter_lncRNA')

x = 0 

samples <- vector()

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

    # expression level
    df_procod_exp <- file_gencode[file_gencode[,'gene_type'] == 'protein_coding', ]
    b <- df_procod_exp[,a] 
    
    genetypes <- vector()
    genetype_list <- vector()
    for (var in genetype){
        if (var %in% file_gencode[,'gene_type']){
           # get mean expression level of the protein coding genes
           genetype_mean <- mean(as.numeric(file_gencode[file_gencode[,'gene_type'] == var, a]))
           genetype_list <- c(genetype_list, genetype_mean)
           genetypes <- c(genetypes, var)
        }
    }
    
    if (x==0) {
       df_genetype <- genetype_list
       procod_gene <- file_gencode[file_gencode[,'gene_type'] == 'protein_coding','gene_id']
    } else {df_genetype <- rbind(df_genetype, genetype_list)
      }
  
    # get the protein coding genes of each sample
    pro_cod <- file_gencode[file_gencode[,'gene_type'] == 'protein_coding', a]
    if (x==0) {df_procod <- data.frame(pro_cod)
    } else {df_procod <- cbind(df_procod, pro_cod) 
      }
   
    # gene length 
    if (x==0) {
    gene_length <- as.numeric(df_procod_exp[,'chromEnd']) - as.numeric(df_procod_exp[,'chromStart']) 
    exon_length <- as.numeric(df_procod_exp[,'exonic_length'])
    df_genelen <- gene_length
    df_exonlen <- exon_length
    } 
    df_genelen <- rbind(df_genelen, b)
    df_exonlen <- rbind(df_exonlen, b)    
    x = x+1
       
}

colnames(df_genelen) <- df_genelen[1,]
df_genelen <- df_genelen[-1,]
rownames(df_genelen) <- samples

colnames(df_exonlen) <- df_exonlen[1,]
df_exonlen <- df_exonlen[-1,]
rownames(df_exonlen) <- samples

colnames(df_genetype) <- genetypes
rownames(df_genetype) <- samples

df_procod1  <- apply(df_procod, 1, mean)
df_procod1 <- cbind(df_procod1, procod_gene)
colnames(df_procod1) <- c('mean','gene')
df_procod2 <- df_procod1[order(as.numeric(df_procod1[,'mean']), decreasing = TRUE),]

topgene <- df_procod2[1:5000, c('gene','mean')]
l <- length(df_procod2[,'gene'])
midgene <- df_procod2[(l/2-2500):(l/2+2500), c('gene', 'mean')]
bottomgene <- df_procod2[(l-5000):l, c('gene', 'mean')]


write.csv2(df_genelen, paste0(path, 'explevel_genelength.csv'))
write.csv2(df_exonlen, paste0(path,'explevel_exonlength.csv'))
write.csv2(df_genetype, paste0(path,'explevel_genetype.csv'))
write.csv2(topgene, paste0(path,'topgene.csv'))
write.csv2(midgene, paste0(path,'midgene.csv'))   
write.csv2(bottomgene, paste0(path,'bottomgene.csv'))  

}


    
