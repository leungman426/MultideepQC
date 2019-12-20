

dendro_diffexp <- function(path, diffgene) {
file <- read.csv2(paste0(path,diffgene),
                  sep = ',', stringsAsFactors = FALSE)
file <- file[,-1]
file1 <- data.frame(sapply(file[,-1], as.numeric))
file1 <- data.frame(t(file1))
colnames(file1) <- file[,'gene']
hc <- hclust(dist(file1), "ave")
hcdata <- dendro_data(hc, type="rectangle")
p <- ggplot() +
  geom_segment(data=segment(hcdata), aes(x=x, y=y, xend=xend, yend=yend)) +
  geom_text(data=label(hcdata), aes(x=x, y=y, label=label), 
             size=3, fontface = 'bold', hjust = 0.001) +
  coord_flip() +
  scale_y_reverse(expand=c(0.5, 1))

return(p)
}
