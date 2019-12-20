# methylationcallingMetrics methylation vs baseQ
# 1. CGmC, CHmC, CGC, CHC coverage distribution of 0-41 baseQ of each chromosome
methylationcov <- function(filepath, path1) {
sampleID <- c(list.files(filepath))

for (chr in c(1:22, 'X', 'Y')){
  CG_df <- data.frame('cov' = 1:200) 
  CH_df <- data.frame('cov' = 1:200)
 
  samples <- vector()
  
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
          # pos 1, 6, 211, 298
          # the last line is the last empty row
    
          if (file[pos[4]] == "### coverage"){  
         
          # get the lines of 'global methylation' 
          file <- file[(pos[4]+2):(length(file)-1)]
                             
          file <- read.csv(textConnection(file), sep = "\t")
          colnames(file) <- c('cov', 'CG', 'CH')
       
          CG <- file[,'CG']       
          CH <- file[,'CH']
         }      
    CG_df <- cbind(CG_df, CG)   
    CH_df <- cbind(CH_df, CH)        
  }
  colnames(CG_df) <- c('pos', samples)
  colnames(CH_df) <- c('pos', samples)
  
write.csv2(CG_df, paste0(path1, chr, '_cov_CG.csv'))
write.csv2(CH_df, paste0(path1, chr, '_cov_CH.csv'))
}
}
