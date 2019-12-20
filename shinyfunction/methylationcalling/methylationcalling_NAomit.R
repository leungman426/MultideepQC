naomit_fun <- function(file){
  file <- file[,-1]
  # remove the samples with too many NAs
  names <- vector()
  for (name in colnames(file)){
    
    if (sum(is.na(file[,name])) > 0.75*length(file[,name])){
      names <- c(names, name)
    }
  }
  return(names)
}