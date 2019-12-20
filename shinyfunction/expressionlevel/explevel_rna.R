
rna_exp <- function(file) {

a <- file[,'protein_coding']
file1 <- cbind(a, file[,-1])
file1 <- cbind(file[,1], file1)
colnames(file) <- c('samples', 'protein_coding', colnames(file[,-1]))
p1 <- graph_flag(file)
p2 <- outliers_flag(file)

return(list(p1, p2))

}