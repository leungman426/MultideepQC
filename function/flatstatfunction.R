

df_flagstat <- function(filepath, path1) {
var_extend <- c('total alignments',
'non-duplicate, non-secondary non-supplementary reads', 
'such with mapping quality larger than 1',
'such on regarded chromosomes',
'such with both reads on regarded chromosomes',
'such mapping on different chromosomes',
'proper pairs read 1')

var <- c('total',
'total QC-failed reads',
'duplicates',
'duplicates failed',
 'mapped',
'mapped failed',
'paired in sequencing',
'paired in sequencing failed',
'read1',
'read1 failed',
'read2',
'read2 failed',
'properly paired',
'properly paired failed',
'with itself and mate mapped',
'with itself and mate mapped failed',
'singletons',
'singletons failed',
'with mate mapped to a different chr',
'with mate mapped to a different chr failed',
'with mate mapped to a different chr (mapQ larger than 5)',
'with mate mapped to a different chr (mapQ larger than 5) failed')

sampleID <- c(list.files(filepath))

samples <- vector()

df_var <- c(var)
df_extend <- c(var_extend)
  
for (sample in sampleID) {
     a <- vector()
     b <- vector()
     samples <- c(samples, sample)

    if (file.exists(paste0(filepath, sample, '/tumor/paired/merged-alignment/'))){
       path <- paste0(filepath, sample, '/tumor/paired/merged-alignment/qualitycontrol/merged/flagstats/')
       file <- readLines(paste0(path,'tumor_',sample, '_merged.mdup.bam_flagstats.txt'))
       file1 <- readLines(paste0(path,'tumor_',sample, '_merged.mdup.bam_extendedFlagstats.txt'))
    } else if (file.exists(paste0(filepath, sample, '/tumor02/paired/merged-alignment/'))) {
       path <- paste0(filepath, sample, '/tumor02/paired/merged-alignment/qualitycontrol/merged/flagstats/')
       file <- readLines(paste0(path,'tumor02_',sample, '_merged.mdup.bam_flagstats.txt'))
       file1 <- readLines(paste0(path,'tumor02_',sample, '_merged.mdup.bam_extendedFlagstats.txt'))
    } else if (file.exists(paste0(filepath, sample, '/control/paired/merged-alignment/'))) {
       path <- paste0(filepath, sample, '/control/paired/merged-alignment/qualitycontrol/merged/flagstats/')
       file <- readLines(paste0(path,'control_',sample, '_merged.mdup.bam_flagstats.txt'))
       file1 <- readLines(paste0(path,'control_',sample, '_merged.mdup.bam_extendedFlagstats.txt'))
    }     
   
   for (i in seq(1:length(file))){
        a <- c(a, as.numeric(str_extract_all(file, "[0-9]+")[[i]][c(1,2)]))
   }
   df_var <- rbind(df_var, a)

   for (i in seq(1:length(file1))){
        num <- as.numeric(str_extract_all(file1, "[0-9]+")[[i]])
        b <- c(b, num[length(num)])
   }
   df_extend <- rbind(df_extend, b)
   
}
colnames(df_var) <- c(var)
df_var <- df_var[-1,]

colnames(df_extend) <- c(var_extend)
df_extend <- df_extend[-1,]

df_var <- apply(df_var, 2, as.numeric)
df_extend <- apply(df_extend, 2, as.numeric)
per_fun1 <- function(list){
list1 <- list/(df_var[,1])
return(list1)
}
df_var1 <- apply(df_var[,-1], 2, per_fun1)
df_var <- cbind(df_var[,'total'], df_var1)
df_extend <- apply(df_extend, 2, per_fun1)
colnames(df_var) <- c(var)
rownames(df_var) <- samples
rownames(df_extend) <- samples
write.csv2(df_var, paste0(path1,'flagstat.csv'))
write.csv2(df_extend, paste0(path1,'flagstat_extend.csv'))

}
