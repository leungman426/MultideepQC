# Title     : TODO
# Objective : TODO
# Created by: wenliang
# Created on: 29.06.18
outliers_function <- function(df, var1, value1){
        # get the outliers data from the boxplot
        a <- boxplot(df[,'value'] ~ df[,'chromosomes'])
        outliers <- a$out

            # subset the dataframe with only outliers
            outliers <- df[df[,'value'] %in% outliers,]
            # outliers table
            outlier_table <- data.frame('sampleID' = outliers$samples,
                                        'Chromosomes' = outliers$chromosomes,
                                        'Value' = outliers$value)
            colnames(outlier_table) <- c('sampleID', var1, value1)
            return(outlier_table)
}
