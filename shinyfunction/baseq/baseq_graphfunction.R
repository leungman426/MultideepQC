

m <- list(
  l = 50,
  r = 50,
  b = 100,
  t = 100,
  pad = 4
)

graph_fun_baseq <- function(file ,tle){
  file1 <- file[,-1]
  file1 <- gather(file1, key = 'samples', value = 'counts', -pos)
  file1$counts <- as.numeric(file1$counts)
  
  p <- ggplot(data = file1, aes(x = pos, y = counts, color = samples)) +
    geom_point(size = 1) + 
    labs(x = 'BaseQ', y = 'Methylation Level', title = tle) + 
    theme(legend.position = "none")
  
  l <- plotly_build(p)$x
  l$data <- lapply(l$data, function(tr) { tr[["text"]] <- I(tr[["text"]]); tr })
  p1 <- as_widget(l)  
  
  p2 <- layout(p1, autosize = F, width = 1000, height = 650, margin = m)

   return(p2)
}

