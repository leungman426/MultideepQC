
genemapping <- function(file){
file1 <- file[,c('samples', 'Intronic Rate', 'Exonic Rate', "Intergenic Rate")]
# three col don't have the same scale
file1[,'Exonic Rate'] <- as.numeric(file1[,'Exonic Rate'])*100
file1[,'Intronic Rate'] <- as.numeric(file1[,'Intronic Rate'])*100
file1[,'Intergenic Rate'] <- as.numeric(file1[,'Intergenic Rate'])*100
file1 <- file1[order(file1[,'Intergenic Rate'], decreasing = TRUE),]

p <- graph_rnaseq(file1, 'Comparisons of Percentage of Reads mapped to Exon, Intron and Intergenic Region')
return(p)
}
