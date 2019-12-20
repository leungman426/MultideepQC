

rrnarate <- function(file){
colnames(file) <- c('samples', colnames(file[,-1]))
file1 <- file[,c('samples', 'rRNA Rate')]
file1[,'rRNA Rate'] <- as.numeric(file1[,'rRNA Rate'])*100
file1 <- file1[order(file1[,'rRNA Rate'], decreasing = TRUE),]

df <- gather(file1, key = 'variables', value = 'value', -samples)
p <- ggplot(df, aes(x = as.character(0), y = value)) + 
  geom_boxplot() + 
  scale_y_continuous(breaks = c(seq(0,1,by = 0.1), 55)) + 
  # coord_trans(y="log2") +  # log2 coordinate transformation (with visually-diminishing spacing)
  geom_jitter(cex=0.5) +
  labs(x = 'rRNA Rate', y = 'read mapped to rRNA(%)')

m <- list(l = 80, r = 50, b = 120, t = 100, pad = 4)
p1 <- ggplotly(p)
p2 <- style(p1, text = paste0(file1[,'samples'], ' value:', file1[,'rRNA Rate']) , hoverinfo="text") %>%
       layout(autosize = F, width = 500, height = 600, margin = m, yaxis = list(type="log", autorange=TRUE))

return(p2)
}
