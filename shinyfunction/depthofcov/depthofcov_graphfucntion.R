# data tidyup for the dataframe with col: samples; row: chromosomes 


m <- list(
  l = 50,
  r = 50,
  b = 100,
  t = 100,
  pad = 4
)

graph_function <- function(df, tle, xlab, ylab){
        # get the outliers data from the boxplot

         p <- ggplot(df, aes(x=df$chromosomes, y=df$value))
         p1 <- p + geom_boxplot(outlier.size = 0.2)  +
                   labs(x = xlab, y = ylab, title = tle) +
                   geom_jitter(cex=1)
         p2 <- ggplotly(p1)
         p2 <- style(p2, text = paste0('sample: ', df[,'samples'], ' Y: ', df[,'value']) , hoverinfo = "text") %>%
                layout(autosize = F, width = 600, height = 500, margin = m)

         return(p2)
}




