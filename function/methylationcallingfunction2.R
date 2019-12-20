# get the samples combined file
# separate the strand 

combined_fun <- function(par, filepath, path){

sampleID <- c(list.files(filepath))

for (chr in c(1:22, 'X', 'Y')){
     samples <- vector()
     x = 0
     for (sample in sampleID) {
          samples <- c(samples, sample)
          file <- read.csv2(paste0(path, chr, '_', sample, '_', par,'_CG.csv'), sep = ';')
          # delete the per-sample bias files
          file.remove(paste0(path, chr, '_', sample, '_', par,'_CG.csv'))
          new_file <- data.frame('chromosome' = file[,'chromosome'], 'cpg' = file[,'cpg'], 'strand' = file[,'strand'], 
                                'methylation_ratio' = file[,'methy']/(file[,'methy']+file[,'unmethy']))
          # write.csv2(new_file, paste0('/home/liangwe/wgbs_rscripts/methy_freq/data2/',chr,'_',sample,'_','CG.csv'))
             
              file_plus <- new_file[new_file[,'strand'] == '+',]
              file_minus <- new_file[new_file[,'strand'] == '-',]
              #cg_mc_plus <- file_plus$V6/(file_plus$V6+file_plus$V7)
              #cg_mc_minus <- file_minus$V6/(file_minus$V6+file_minus$V7)
              cg_mc_plus <- file_plus[,'methylation_ratio']
              cg_mc_minus <- file_minus[,'methylation_ratio']
              
              if (x == 0){ cg_mc_plusdf <- cg_mc_plus
                         cg_mc_minusdf <- cg_mc_minus
                        
              }
              
              else {
                   cg_mc_plusdf <- cbind(cg_mc_plusdf, cg_mc_plus)
                   cg_mc_minusdf <- cbind(cg_mc_minusdf, cg_mc_minus)
              }
         
              x = x+1
     }
     
     colnames(cg_mc_plusdf) <- samples
     write.csv2(cg_mc_plusdf , paste0(path, chr, '_', 'plus_', par, 'CG.csv'))
     colnames(cg_mc_minusdf) <- samples
     write.csv2(cg_mc_minusdf , paste0(path, chr, '_', 'minus_', par, 'CG.csv'))
} 
}         
