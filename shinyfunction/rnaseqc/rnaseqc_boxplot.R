
rnaseqc <- function(file, title, w, h){
format1 <- function(list) {
  list <- format(as.numeric(list), digits = 4)
  return(list)
}

file1 <- apply(file[,-1], 2, format1)
file1 <- data.frame(apply(file[,-1], 2, as.numeric))
file1['samples'] <- file[,'samples']
p1 <- graph_flag(file1, w, h, title)
p2 <- outliers_flag(file1, 'Read Counts')

return(list(p1, p2))

}
