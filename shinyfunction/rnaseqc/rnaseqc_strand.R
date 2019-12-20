
strands <- function(file){
file1 <- file[,c('samples', 'End1 Percentage Sense', "End2 Percentage Sense")]
file1[,'End1 Percentage Sense'] <- as.numeric(file1[,'End1 Percentage Sense'])
file1[,'End2 Percentage Sense'] <-  as.numeric(file1[,'End2 Percentage Sense'])

if (sum(file1[,'End1 Percentage Sense']) > sum(file1[,'End2 Percentage Sense'])) {
  a <- file1[,'End1 Percentage Sense']
} else { # make sure the else occurs on the same line as the end of the 
          #if clause so that R knows to keep reading
  a <- file1[,'End2 Percentage Sense']
  }
file1 <- file1[order(a, decreasing = TRUE),]

p <- graph_rnaseq(file1, 'Percentage of sense End1/End2 ')
return(p)
}
