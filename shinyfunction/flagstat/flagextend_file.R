flagextend_file <- function(path, par) {
  file <- read.csv2(paste0(path, par, '.csv'))
  colnames(file) <- c('samples',                                             
                      "total alignments",                                     
                      "non duplicate/non secondary/non supplementary reads", 
                      "such with mapping quality > 1",             
                      "such on regarded chromosomes",                        
                      "such with both reads on regarded chromosomes",         
                      "such mapping on different chromosomes",                
                      "proper pairs read 1")
  return(file)
}


