# methylationcallingMetrics methylation vs position 
# 1. CGmC, CHmC, CGC, CHC coverage at each position of the read of each chromosome
# 2. coveage percentage of mC at CG, CH at at each position of the read of each chromosome
# 3. heatmap for each chromosome
methylation_pos <- function(filepath, path1) {
sampleID <- c(list.files(filepath))

for (chr in c(1:22, 'X', 'Y')){
  CG_mC_ratio_mate1 <- data.frame('position' =1:125)
  CG_mC_ratio_mate2 <- data.frame('position' =1:125) 

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
          # pos 1, 6, 211, 298, 501 
          # pos 501 is the last empty row
    
          if (file[pos[2]] == "### methylation vs. position"){  
            
          # get the lines of 'global methylation' 
          file <- file[(pos[2]+1):(pos[3]-2)]

          file <- read.csv(textConnection(file), sep = "\t")
          CG_mC <- file$CG.mC       
          CG_C <- file$CG.C
         
         
          fillNA <- function(var){
            if (length(var) < 250) {
              var1 <- var[1:101]
              var2 <- var[102:202]
              var1 <- c(var1, rep(NA, 125-101))
              var2 <- c(var2, rep(NA, 125-101))
              var <- c(var1, var2)
            }
            var <- var
          }
          CGmC <- fillNA(CG_mC)
          CGC <- fillNA(CG_C)
         
          CGmC1 <- CGmC[1:125]
          CGmC2 <- CGmC[126:250]
          CGC1 <- CGC[1:125]
          CGC2 <- CGC[126:250]

          CGmC_ratio_mate1 <- CGmC1/(CGmC1 + CGC1)
          CGmC_ratio_mate2 <- CGmC2/(CGmC2 + CGC2)
         }
    CG_mC_ratio_mate1 <- cbind(CG_mC_ratio_mate1, CGmC_ratio_mate1)
    CG_mC_ratio_mate2 <- cbind(CG_mC_ratio_mate2, CGmC_ratio_mate2)
   }

  colnames(CG_mC_ratio_mate1) <- c('pos',samples)
  colnames(CG_mC_ratio_mate2) <- c('pos',samples)

  write.csv2(CG_mC_ratio_mate1, paste0(path1, chr, '_position_mate1_CG_mC_ratio.csv'))
  write.csv2(CG_mC_ratio_mate2, paste0(path1, chr, '_position_mate2_CG_mC_ratio.csv'))
  }
}
