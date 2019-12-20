# combine the samples for the chr_endtoend_combined files

methylationcalling_merged <- function(filepath, path, pathmerged, par){

sampleID <- c(list.files(filepath))
x=0
samples <- vector()
for (sample in sampleID) {
     samples <- c(samples, sample)
          file <- read.csv2(paste0(path, pathmerged, sample, '_', par,'_CG.csv'))
          # delete the per-sample bias files
          file.remove(paste0(path, pathmerged, sample, '_', par,'_CG.csv'))
          new_file <- data.frame('chromosome' = file[,'chromosome'], 'cpg' = file[,'cpg'], 'strand' = file[,'strand'], 
                                'methylation_ratio' = file[,'methy']/(file[,'methy']+file[,'unmethy']))
          file_plus <- new_file[new_file[,'strand'] == '+',]
          file_minus <- new_file[new_file[,'strand'] == '-',]
          cg_mc_plus <- file_plus[,'methylation_ratio']
          cg_mc_minus <- file_minus[,'methylation_ratio']
          

          if (x == 0){ cg_mc_plusdf <- cg_mc_plus
                       cg_mc_minusdf <- cg_mc_minus
                        
          }
              
          else { cg_mc_plusdf <- cbind(cg_mc_plusdf, cg_mc_plus)
                 cg_mc_minusdf <- cbind(cg_mc_minusdf, cg_mc_minus)
           }
         
              x = x+1
     }
     colnames(cg_mc_plusdf) <- samples
     write.csv2(cg_mc_plusdf , paste0(path, pathmerged, 'plus_', par, 'CG.csv'))
     colnames(cg_mc_minusdf) <- samples
     write.csv2(cg_mc_minusdf , paste0(path, pathmerged, 'minus_', par, 'CG.csv'))

}
