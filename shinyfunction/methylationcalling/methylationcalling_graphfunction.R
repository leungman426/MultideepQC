

m <- list(l = 50, r = 50, b = 100, t = 100, pad = 4)

graph_fun_freq<- function(file ,tle){
  file <- file[, -1]
  file1 <- gather(file, key = 'samples', value = 'counts')
  file1$counts <- as.numeric(file1$counts)
  
 
p <- ggplot(data = file1, aes(x = counts,  color = samples)) +
    geom_line(stat='density') +
    labs(x = 'Methylation Level per CpG site', y = 'Density', title = tle) +
    theme(legend.position = "none")

# hoverinfo does not work with color mapping
l <- plotly_build(p)$x
l$data <- lapply(l$data, function(tr) { tr[["text"]] <- I(tr[["text"]]); tr })
p1 <- as_widget(l)  
   
   p1 <- layout(p1, autosize = F, width = 1000, height = 800, margin = m)

   return(p1)
}


