

graph_cor <- function(file, samplename, length) {

if (samplename == 'all') {
   df1 <- gather(file, key = 'GeneLength', value = 'ExpressionLevel', -samples)
   df1[,'GeneLength'] <- as.numeric(df1[,'GeneLength'])
   df1[,'ExpressionLevel'] <- as.numeric(df1[,'ExpressionLevel'])
   a <- log10(df1[,'ExpressionLevel'])
   df2 <- df1[!is.infinite(a),]
   coreff <- cor(log10(df2[,'GeneLength']), log10(df2[,'ExpressionLevel']))

   samplenames <- file[,'samples']
   corefflist <- vector()
   for (sample in samplenames) {
       df3 <- df2[df2[,'samples'] == sample, ]
       coreff1 <- cor(log10(df3[,'GeneLength']), log10(df3[,'ExpressionLevel']))
       corefflist <- c(corefflist, coreff1)
    }
}

if (samplename != 'all' && samplename != 'mean'){
   df <- gather(file, key='GeneLength', value = 'ExpressionLevel', -samples)
   df[,'GeneLength'] <- as.numeric(df[,'GeneLength'])
   df[,'ExpressionLevel'] <- as.numeric(df[,'ExpressionLevel'])
   df1 <- df[order(df[,'GeneLength'], decreasing = TRUE),]
   df1 <- df1[df1[,'samples'] == samplename,]
}

if (samplename == 'mean'){
  # get the mean value of all samples for each gene
  value <- apply(file[,-1], 2, mean)
  genelength <- as.numeric(colnames(file[,-1]))
  df1 <- data.frame(cbind(value, genelength))
  colnames(df1) <- c('ExpressionLevel', 'GeneLength')
}

a <- log10(df1[,'ExpressionLevel']+1)
df2 <- df1[!is.infinite(a),]
coreff <- cor(log10(df2[,'GeneLength']), log10(df2[,'ExpressionLevel']+1))

if (samplename == 'all') {
p <- ggplot(df1, aes(x = log10(df1[,'GeneLength']), y = log10(df1[,'ExpressionLevel']+1), colour = samples)) +
         theme(legend.position = "none") +
         geom_smooth( method = "gam", se = FALSE) +
         labs(title = paste0('Correlation between Expression Level and ', length ,
                             "  Correlation Coefficient: ", coreff),
              x = paste0(length, '(log10)'), y = 'Gene Expression Level (log10)')

m <- list(l = 50, r = 50, b = 120, t = 100, pad = 4)
p1 <- ggplotly(p) %>%
    layout(autosize = F, width = 1000, height = 800, margin = m)
p1 <- style(p1, text = paste0('Cor:', corefflist, ' samples: ',file[,'samples']), hoverinfo="text")
  
} else  {
p <- ggplot(df1, aes(x = log10(df1[,'GeneLength']), y = log10(df1[,'ExpressionLevel']+1))) +
     theme(legend.position="none") +
     geom_point(colour = 'red') +
     geom_smooth(method = "gam", se = FALSE, colour = 'black') +
     labs(title = paste0(' Correlation between Expression Level (TMP) and ', length ,
                         '  (sample: ', samplename, ')'),
          x = paste0(length, '(log10)'), y = 'Gene Expression Level  (log10(X+1))') #+
    # annotate("text", x = 5, y = 4, label = paste0("Correlation Coefficient: ", coreff))

m <- list(l = 50, r = 50, b = 120, t = 100, pad = 4)
p1 <- ggplotly(p)
p1 <- style(p1, text = ~n, hoverinfo = 'text', 
            hovertext = paste("Gene Length:", log10(df1[,'GeneLength']),
                              "<br> Expression Level:", log10(df1[,'ExpressionLevel']+1))) %>%
         layout(autosize = F, width = 1000, height = 800, margin = m) %>%
         add_annotations(x = 2.3,
                         y = 3.3, showarrow = FALSE,
                         text = paste0("Correlation Coefficient: ", format(coreff, digits = 2)))
          
}
return(p1)
}
