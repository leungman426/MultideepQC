
outliers_flag <- function(file, value1){
  # get the outliers data from the boxplot
  df <- gather(file, key = 'var', value = 'value', -samples)
  a <- boxplot(df[,'value'] ~ df[,'var'])
  outliers <- a$out
  
  # subset the dataframe with only outliers
  outliers <- df[df[,'value'] %in% outliers,]
  # outliers table
  outlier_table <- data.frame('sampleID' = outliers$samples,
                              'Variables' = outliers$var,
                              value = outliers$value)
   colnames(outlier_table) <- c('sampleID', 'Variables', value1)
  return(outlier_table)
}
