

gather_fun_globalmethy <- function(filepath, tle){
  df <- read.csv2(paste0(filepath, tle, '.csv'), sep = ',', stringsAsFactors = FALSE)[,-c(1,2)]
  df <- data.frame(t(df))
  colnames(df) <- c(1:22, 'X', 'Y')
  # add the col 'samples'
  df['samples'] <- rownames(df)
  # group the coverage by chr and sample names
  df <- gather(df, key = 'chromosomes', value = 'value', -samples)
  df$value <- as.numeric(df$value)
  return(df)
}

