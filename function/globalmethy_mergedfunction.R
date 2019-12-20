
bp_chr <- c(248956422,242193529,198295559,190214555,181538259,170805979,159345973,
145138636,138394717,133797422,135086622,133275309,114364328,107043718,101991189,
90338345,83257441,80373285,58617616,64444167,46709983,50818468,156040895,57227415)

weight_chr <- bp_chr/sum(bp_chr)

meanfun <- function(list){
  newlist <- weighted.mean(list, weight_chr)
} 

globalmethy_merged <- function(filepath, mergedpath){
     filenames <- list.files(filepath, pattern = '_globalmethylation.csv')
     dir.create(paste0(filepath, 'globalmethy_merged/'))
     for (filename in filenames) {     
          file <- read.csv2(paste0(filepath, filename), sep = ',',
                            stringsAsFactors = FALSE)[,-c(1,2)]    
          # value of the CG,CH_ratio is character
          file <- apply(file, 2, as.numeric)          
          df_mean <-   apply(file, 2, meanfun)
          df_median <- apply(file, 2, median) 
          df_sum <-    apply(file, 2, sum) 
    
          name <- strsplit(filename, '.csv')[[1]]
          write.csv2(df_mean,   paste0(filepath, mergedpath, 'mean_', name,'.csv'))
          write.csv2(df_median, paste0(filepath, mergedpath, 'median_', name,'.csv')) 
          write.csv2(df_sum,    paste0(filepath, mergedpath, 'sum_', name,'.csv'))
     }
     return(list(df_mean, df_median, df_sum))
}
