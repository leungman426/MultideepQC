

df_retrival <- function(filepath, variable, filepath1){

        # otherwise, error 'Error in file[1] : object of type 'closure' is not subsettable' 
        sampleID <- c(list.files(filepath))
        # for each cov variables, create a df for all samples
        df <- data.frame('chromosome' = c(1:22, 'X', 'Y'))

        samples <- vector()      
        # read the file of each sample
        for (sample in sampleID) {
               
            if (file.exists(paste0(filepath, sample, '/tumor/paired/merged-alignment/'))){
                path <- paste0(filepath, sample, '/tumor/paired/merged-alignment/qualitycontrol/merged/coverage/')
                file <- read.csv2(paste0(path,'tumor','_',sample, '.DepthOfCoverage_Genome.txt'), 
                                  sep = '\t', stringsAsFactors = FALSE)}

           if (file.exists(paste0(filepath, sample, '/tumor02/paired/merged-alignment/'))) {
                path <- paste0(filepath, sample, '/tumor02/paired/merged-alignment/qualitycontrol/merged/coverage/')
                file <- read.csv2(paste0(path,'tumor02','_',sample, '.DepthOfCoverage_Genome.txt'), 
                                  sep = '\t', stringsAsFactors = FALSE)}

           if (file.exists(paste0(filepath, sample, '/control/paired/merged-alignment/'))) {
                path <- paste0(filepath, sample, '/control/paired/merged-alignment/qualitycontrol/merged/coverage/')
                file <- read.csv2(paste0(path,'control','_',sample, '.DepthOfCoverage_Genome.txt'), 
                                  sep = '\t', stringsAsFactors = FALSE)}   
            
          # collect the sample name to make the new col names 
          samples <- c(samples, sample)
    
          # only select the chromosome 1:22, X, Y
          file <- file[file$interval %in%  c(1:22,'X','Y'),]

          if (variable == 'coverage.QC.bases'| variable == 'genome_w.o_N.coverage.QC.bases'){
              file$coverage.QC.bases <- unlist(strsplit(file$coverage.QC.bases, 'x'))
              file$genome_w.o_N.coverage.QC.bases <- unlist(strsplit(file$genome_w.o_N.coverage.QC.bases, 'x'))
          }

          # transform the column into mapped reads percentage
          if (variable == 'X.QC.bases..total.bases'){
              split1 <- strsplit(file$X.QC.bases..total.bases, '/')
              mappedread_per <- vector()
              for (len in (1:length(split1))) {
                   mappedread_per <- c(mappedread_per, as.numeric(split1[[len]][2])/as.numeric(split1[[len]][1]))

               }
              file$X.QC.bases..total.bases <- mappedread_per
          }
          if (variable == 'X.QC.bases..total.not_N.bases') {
              split2 <- strsplit(file$X.QC.bases..total.not_N.bases, '/')
              notNmappedread_per <- vector()
              for (len in (1:length(split2))) {
                   notNmappedread_per <- c(notNmappedread_per, as.numeric(split2[[len]][2])/as.numeric(split2[[len]][1]))
              }
              file$X.QC.bases..total.not_N.bases <- notNmappedread_per
          }

      # combine the col from various samples
      var <- as.numeric(file[,variable])
      df <- cbind(df, var)
  }
      colnames(df) <- c('chromosome', samples)
      write.csv2(df, paste0(filepath1, '/depthofcov/',variable, '.csv'))
}
