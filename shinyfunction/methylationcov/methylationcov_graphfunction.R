

m <- list(
  l = 80,
  r = 50,
  b = 100,
  t = 100,
  pad = 4
)

graph_fun_methycov <- function(file ,tle, ylab){
  file <- file[,-1]
  file1 <- gather(file, key = 'samples', value = 'counts', -pos)
  file1$counts <- as.numeric(file1$counts)
  
  p <- ggplot(data = file1, aes(x = log2(pos), y = counts,
                               color = samples)) +
    geom_line() + 
    labs(x = 'Coverage (log2(number of the reads))', y = ylab, title = tle) 
 
  
  p1 <- p + theme(legend.position = "none")

  l <- plotly_build(p1)$x
  l$data <- lapply(l$data, function(tr) { tr[["text"]] <- I(tr[["text"]]); tr })
  p2 <- as_widget(l)  
  
  p2 <- layout(p2, autosize = F, width = 1100, height = 800, margin = m)

  return(p2)
}

