# methylationcallingMetrics global methylation: CGmC,CHmC,CGC,CHC coverage of each chromosome
# 1. CGmC,CHmC,CGC,CHC coverage of each chromosome for each sample
# 2. mean and median CGmC,CHmC,CGC,CHC coverage of all chromosomes for each sample
# 3. boxplot for each chromosomes; boxplot for merged

globalmethy <- function(filepath, path) {

sampleID <- c(list.files(filepath))

CG_mCdf <- data.frame('chromosome' = c(1:22, 'X', 'Y'))
CH_mCdf <- data.frame('chromosome' = c(1:22, 'X', 'Y'))
CG_Cdf <- data.frame('chromosome' = c(1:22, 'X', 'Y'))
CH_Cdf <- data.frame('chromosome' = c(1:22, 'X', 'Y'))
CG_ratiodf <- data.frame('chromosome' = c(1:22, 'X', 'Y'))
CH_ratiodf <- data.frame('chromosome' = c(1:22, 'X', 'Y'))

samples <- vector()

for (sample in sampleID) {
  

        # collect the sample name to make the new col names 
        samples <- c(samples, sample)
        CG_mC <- vector()
        CH_mC <- vector()
        CG_C <- vector()
        CH_C <- vector()
        CG_ratio <- vector()
        CH_ratio <-vector()
        
        # extract each chromosome rows data by each sample
        # create the file names 
        for (chr in c(1:22, 'X', 'Y')){  
             if (file.exists(paste0(filepath, sample, '/tumor/paired/merged-alignment/'))){
                   path1 <- paste0(filepath, sample, '/tumor/paired/merged-alignment/methylation/merged/methylationCallingMetrics/')
                   file <- paste0(path1,'tumor','_',sample,'_merged.mdup.bam.',chr,'.metrics.csv')
             } else if (file.exists(paste0(filepath, sample, '/tumor02/paired/merged-alignment/'))) {
                   path1 <- paste0(filepath, sample, '/tumor02/paired/merged-alignment/methylation/merged/methylationCallingMetrics/')
                   file <- paste0(path1,'tumor02','_',sample,'_merged.mdup.bam.',chr,'.metrics.csv')
             } else if (file.exists(paste0(filepath, sample, '/control/paired/merged-alignment/'))) {
                   path1 <- paste0(filepath, sample, '/control/paired/merged-alignment/methylation/merged/methylationCallingMetrics/')
                   file <- paste0(path1,'control','_',sample,'_merged.mdup.bam.',chr,'.metrics.csv')}   
             
             file1 <- readLines(file)
             # get the position of the beginning of each part 
             pos <- c(grep("^###*",file1, length(file1)))
             # pos 1, 6, 211, 298, 501 
             # pos 501 is the last empty row 
            
             if (file1[pos[1]] == '### global methylation'){
                  # get the lines of 'global methylation' 
                  global_met <- file1[(pos[1]+1):(pos[2]-2)]
                  # change the lines into dataframe 
                  global_met <- read.csv(textConnection(global_met), sep = "\t")
                  CG_mC <- c(CG_mC, global_met[1,'mC']) 
                  CH_mC <- c(CH_mC, global_met[2,'mC'])
                  CG_C <- c(CG_C, global_met[1,'C'])
                  CH_C <- c(CH_C, global_met[2,'C'])
                  CG_ratio <- c(CG_ratio, global_met[1,'ratio'])
                  CH_ratio <- c(CH_ratio, global_met[2,'ratio']) 
                 }
        }
        
        CG_mCdf <- cbind(CG_mCdf, CG_mC)
        CH_mCdf <- cbind(CH_mCdf, CH_mC)
        CG_Cdf <- cbind(CG_Cdf, CG_C)
        CH_Cdf <- cbind(CH_Cdf, CH_C)
        CG_ratiodf <- cbind(CG_ratiodf, CG_ratio)
        CH_ratiodf <- cbind(CH_ratiodf, CH_ratio)
        
}

colnames(CG_mCdf)<-c('chromosomes', samples)
colnames(CH_mCdf)<-c('chromosomes', samples)
colnames(CG_Cdf)<-c('chromosomes', samples)
colnames(CH_Cdf)<-c('chromosomes', samples)
colnames(CG_ratiodf)<-c('chromosomes', samples)
colnames(CH_ratiodf)<-c('chromosomes', samples)

write.csv(CG_mCdf, paste0(path, 'CG_mC_globalmethylation.csv'))
write.csv(CH_mCdf , paste0(path, 'CH_mC_globalmethylation.csv'))
write.csv(CG_Cdf, paste0(path, 'CG_C_globalmethylation.csv'))
write.csv(CH_Cdf, paste0(path, 'CH_C_globalmethylation.csv'))
write.csv(CG_ratiodf, paste0(path, 'CG_ratio_globalmethylation.csv'))
write.csv(CH_ratiodf, paste0(path, 'CH_ratio_globalmethylation.csv'))

}
