merge_function <- function(filepath, mergefile, row_strat, row_end, filepattern){

bp_chr <- c(248956422,242193529,198295559,190214555,181538259,170805979,159345973,
145138636,138394717,133797422,135086622,133275309,114364328,107043718,101991189,
90338345,83257441,80373285,58617616,64444167,46709983,50818468,156040895,57227415)

weight_chr <- bp_chr/sum(bp_chr)

meanfun <- function(list){
  newlist <- weighted.mean(list, weight_chr)
} 

# select the variables key words in the file names
for (i in filepattern) {
    # some better unify the filenames and place files into differents folders
    filenames <- list.files(filepath, pattern = i)
    # to obtain the sample names
    file <- read.csv2(paste0(filepath, filenames[1]), sep = ';')[,c(-1,-2)]
    samples <- colnames(file)
   
    df_mean <-  data.frame('pos' = row_strat:row_end)
    df_median <-  data.frame('pos' = row_strat:row_end)
    df_sum <-  data.frame('pos' = row_strat:row_end)
   
    for (sample in samples) {
        df <- data.frame('pos' = row_strat:row_end)
        # open the specific variable files of all the chromosomes
        for (file in filenames) {
            file1 <- read.csv2(paste0(filepath, file), 
                              sep = ';')
            # combine one sample column of all the chromosomes
            df <- cbind(df, file1[,sample])
        }
       
        # obtain the mean and median of all chromosomes for each row
        merged_mean <- apply(df[,-1], 1, meanfun)
        merged_median <- apply(df[,-1], 1, median)
        merged_sum <- apply(df[,-1], 1, sum)

        # combine that mean and median value of each sample
        df_mean <- cbind(df_mean, merged_mean)
        df_median <- cbind(df_median, merged_median)
        df_sum <- cbind(df_sum, merged_sum)
    }

    colnames(df_mean) <- c('pos', samples)
    colnames(df_median) <- c('pos', samples)
    colnames(df_sum) <- c('pos', samples)

    write.csv2(df_mean, paste0(filepath, mergefile,'mean_',file))
    write.csv2(df_median, paste0(filepath, mergefile, 'median_',file))
    write.csv2(df_sum, paste0(filepath, mergefile, 'sum_',file))
}
}
