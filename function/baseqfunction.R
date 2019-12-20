# methylationcallingMetrics methylation vs baseQ
# 1. CGmC, CHmC, CGC, CHC coverage distribution of 0-41 baseQ of each chromosome

baseq <- function(filepath, path1) {
sampleID <- c(list.files(filepath))

for (chr in c(1:22, 'X', 'Y')){
  CG_mCdf_mate1 <- data.frame('baseq' = 0:41) 
  CH_mCdf_mate1 <- data.frame('baseq' = 0:41)
  CG_mCdf_mate2 <- data.frame('baseq' = 0:41) 
  CH_mCdf_mate2 <- data.frame('baseq' = 0:41)
  samples <- vector()
  nonexitsamples <- vector()
  
  for (sample in sampleID) {
    
      if (file.exists(paste0(filepath, sample, '/tumor/paired/merged-alignment/'))){
          path <- paste0(filepath, sample, '/tumor/paired/merged-alignment/methylation/merged/methylationCallingMetrics/')
          file <- paste0(path,'tumor','_',sample,'_merged.mdup.bam.',chr,'.metrics.csv')
      } else if (file.exists(paste0(filepath, sample, '/tumor02/paired/merged-alignment/'))) {
          path <- paste0(filepath, sample, '/tumor02/paired/merged-alignment/methylation/merged/methylationCallingMetrics/')
          file <- paste0(path,'tumor02','_',sample,'_merged.mdup.bam.',chr,'.metrics.csv')
      } else if (file.exists(paste0(filepath, sample, '/control/paired/merged-alignment/'))) {
          path <- paste0(filepath, sample, '/control/paired/merged-alignment/methylation/merged/methylationCallingMetrics/')
          file <- paste0(path,'control','_',sample,'_merged.mdup.bam.',chr,'.metrics.csv')
      }   
          samples <- c(samples, sample)
          # extract each chromosome rows data by each sample
          # create the file names 
              
          file <- readLines(file)

          # get the position of the beginning of each part 
          pos <- c(grep("^###*",file, length(file)))
          # pos 1, 6, 211, 298, 501 
          # pos 501 is the last empty row
    
          if (file[pos[3]] == "### methylation vs. baseQ"){  
         
          # get the lines of 'global methylation' 
          file_mate1 <- file[(pos[3]+1):(pos[3]+1+42)]
         
          file_mate2 <- file[(pos[3]+1+41+1):(pos[4]-2)]
          
          file_mate1 <- read.csv(textConnection(file_mate1), sep = "\t")
          colnames(file_mate1) <- c('mate','pos2','cgmc','cgc','chmc','chc')
          
          file_mate2 <- read.csv(textConnection(file_mate2), sep = "\t")
          colnames(file_mate2) <- c('mate','pos2','cgmc','cgc','chmc','chc')
           
          CG_mC_mate1 <- file_mate1[,'cgmc']       
          CG_C_mate1 <- file_mate1[,'cgc']
          cgmc_ratio_mate1 <- CG_mC_mate1/(CG_mC_mate1+CG_C_mate1)

          # divided by 0 turns out to be NA
          cgmc_ratio_mate1 <- replace(cgmc_ratio_mate1, is.na(cgmc_ratio_mate1), 0)
          CH_mC_mate1 <- file_mate1[,'chmc']
          CH_C_mate1 <- file_mate1[,'chc']
          chmc_ratio_mate1 <- CH_mC_mate1/(CH_mC_mate1+CH_C_mate1)
          chmc_ratio_mate1 <- replace(chmc_ratio_mate1, is.na(chmc_ratio_mate1), 0)
                      
          CG_mC_mate2 <- file_mate2[,'cgmc']    
          CG_C_mate2 <- file_mate2[,'cgc']
          cgmc_ratio_mate2 <- CG_mC_mate2/(CG_mC_mate2+CG_C_mate2)
          cgmc_ratio_mate2 <- replace(cgmc_ratio_mate2, is.na(cgmc_ratio_mate2), 0)
          CH_mC_mate2 <- file_mate2[,'chmc']
          CH_C_mate2 <- file_mate2[,'chc']
          chmc_ratio_mate2 <- CH_mC_mate2/(CH_mC_mate2+CH_C_mate2)
          chmc_ratio_mate2 <- sub(NA, 0, chmc_ratio_mate2)
          chmc_ratio_mate2 <- replace(chmc_ratio_mate2, is.na(chmc_ratio_mate2), 0)
         }
      
    CG_mCdf_mate1 <- cbind(CG_mCdf_mate1, cgmc_ratio_mate1)   
    CH_mCdf_mate1 <- cbind(CH_mCdf_mate1, chmc_ratio_mate1)
    CG_mCdf_mate2 <- cbind(CG_mCdf_mate2, cgmc_ratio_mate2)   
    CH_mCdf_mate2 <- cbind(CH_mCdf_mate2, chmc_ratio_mate2)
    
  }
  colnames(CG_mCdf_mate1) <- c('pos', samples)
  colnames(CH_mCdf_mate1) <- c('pos', samples)
  colnames(CG_mCdf_mate2) <- c('pos', samples)
  colnames(CH_mCdf_mate2) <- c('pos', samples)
  
write.csv2(CG_mCdf_mate1, paste0(path1, chr, '_baseq_mate1_CG_mC_ratio.csv'))
write.csv2(CH_mCdf_mate1, paste0(path1, chr, '_baseq_mate1_CH_mC_ratio.csv'))
write.csv2(CG_mCdf_mate2, paste0(path1, chr, '_baseq_mate2_CG_mC_ratio.csv'))
write.csv2(CH_mCdf_mate2, paste0(path1, chr, '_baseq_mate2_CH_mC_ratio.csv'))
}
}
