
#m <- list(l = 50, r = 50, b = 100, t = 100, pad = 4)

graph_fun_baseq1 <- function(file){
  file1 <- file[,-1]
  file1 <- gather(file1, key = 'samples', value = 'counts', -pos)
  file1$counts <- as.numeric(file1$counts)
  
  p <- ggplot(data = file1, aes(x = pos, y = counts)) +
    geom_violin(aes(group = cut_width(pos, 1 , boundary = 0))) + 
    labs(x = 'BaseQ', y = 'Methylation Level') + 
     theme(legend.position = "none")
   p1 <- ggplotly(p)
   p1 <- style(p1, text = file1[,'samples'] , hoverinfo="text") %>%
        layout(autosize = F, width = 1000, height = 650, margin = m)
  
  return(p1)
}

