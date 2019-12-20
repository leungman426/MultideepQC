library(stringr)

flagstat_rnaseq <- function(filepath, path1) {

var <- c('total', 'total(failed)',   
         'secondary', 'secondary (failed)', 'supplementary', 'supplementary (failed)',
         'duplicates reads', "duplicates (failed)",                                              
           "mapped reads",                                                          
           "mapped (failed)",                                                  
           "paired in sequencing",                                           
           "paired in sequencing (failed)",                                     
           "read1",                                                          
           "read1 (failed)",                                                   
           "read2",                                                           
           "read2 (failed)",                                                   
           "properly paired",                                                
           "properly paired (failed)",                                         
           "with itself and mate mapped",                                    
           "with itself and mate mapped (failed)",                             
           "singletons",                                                      
           "singletons (failed)",                                               
           "with mate mapped to a different chromosomes",                            
           "with mate mapped to a different chromosomes (failed)",                     
           "with mate mapped to a different chromosomes (mapQ>5)",        
           "with mate mapped to a different chromosomes (mapQ>5, failed)"
          )

sampleID <- c(list.files(filepath))

samples <- vector()

df_var <- c(var)

for (sample in sampleID) {
  a <- vector()
  samples <- c(samples, sample)
  
  path <- paste0(filepath, sample, '/tumor/paired/merged-alignment/')
  file <- readLines(paste0(path,'tumor_',sample, '_merged.mdup.bam.flagstat'))
   
  for (i in seq(1:length(file))){
    a <- c(a, as.numeric(str_extract_all(file, "[0-9]+")[[i]][c(1,2)]))
  }
  df_var <- rbind(df_var, a)
  
}
colnames(df_var) <- c(var)
df_var <- df_var[-1,]

df_var <- apply(df_var, 2, as.numeric)

per_fun1 <- function(list){
  list1 <- list/(df_var[,1])
  return(list1)
}
df_var1 <- apply(df_var[,-1], 2, per_fun1)
df_var <- cbind(df_var[,'total'], df_var1)
colnames(df_var) <- c(var)
rownames(df_var) <- samples
write.csv2(df_var, paste0(path1,'flagstat_rna.csv'))

}

  