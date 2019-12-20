groupping <- function(filepath, path) {
sampleID <- c(list.files(filepath))

expsamples <- vector()
ctrlsamples <- vector()
 for (sample in sampleID) {
           if (file.exists(paste0(filepath, sample, '/tumor/paired/merged-alignment/'))|file.exists(paste0(filepath, sample, '/tumor02/paired/merged-alignment/'))){
          expsamples <- c(expsamples, sample)}

      if (file.exists(paste0(filepath, sample, '/control/paired/merged-alignment/'))) {
          ctrlsamples <- c(ctrlsamples,sample)}  
 }
if (length(expsamples) != length(ctrlsamples)) {
   ctrlsamples <- c(ctrlsamples, rep(NA, length(expsamples)-length(ctrlsamples)))
}   
df <- data.frame('tumor' = expsamples, 'control' = ctrlsamples)
write.csv2(df, paste0(path, 'groups.csv'))
}