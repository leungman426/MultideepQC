library(jsonlite)

rnaseq_fun <- function(filepath, path) {
  
sampleID <- c(list.files(filepath))

total <- c(1:5, 16, 19, 33:44, 47, 48, 51)
strand <- c(6:15)
transcripts <- c(17, 18, 20:25, 49)
mapped <- c(26:32, 45, 46, 49, 50, 52:54)

file <- fromJSON(paste0(filepath, sampleID[1],'/tumor/paired/merged-alignment/qualitycontrol/qualitycontrol.json'))
file1 <- unlist(file)
varnames <- names(file1)
totalnames <- varnames[total]
strandnames <- varnames[strand]
transcriptsnames <- varnames[transcripts]
mappednames <- varnames[mapped]

total_df <- c(totalnames)
strand_df <- c(strandnames)
transcripts_df <- c(transcriptsnames)
mapped_df <- c(mappednames)

for (sample in sampleID) {
    file <- fromJSON(paste0(filepath, sample,'/tumor/paired/merged-alignment/qualitycontrol/qualitycontrol.json'))
    file1 <- unlist(file)
    a <- file1[total]
    b <- file1[strand]
    c <- file1[transcripts]
    d <- file1[mapped]
    total_df <- rbind(total_df, a)
    strand_df <- rbind(strand_df, b)
    transcripts_df <- rbind(transcripts_df, c)
    mapped_df <- rbind(mapped_df, d)
}

fun <- function(df, tle){
colnames(df) <- df[1,]
df <- df[-1,]
rownames(df) <- sampleID
write.csv2(df, paste0(path, tle))
}

fun(total_df, 'totalread.csv')
fun(strand_df, 'strandspecificity.csv')
fun(transcripts_df, 'transcriptsreads.csv')
fun(mapped_df, 'mappedread.csv')

}