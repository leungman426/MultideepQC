

pca_diffexp <- function(path, diffgene) {
file <- read.csv2(paste0(path, diffgene),  sep = ',', stringsAsFactors = FALSE)
file <- file[,-1]
file1 <- data.frame(sapply(file[,-1], as.numeric))
file1 <- data.frame(t(file1))
colnames(file1) <- file[,'gene']
df_pca <- prcomp(file1[,-length(colnames(file1))])

pov <- df_pca$sdev^2/sum(df_pca$sdev^2) # proportion of variance 
pc1 <- format(pov[1]*100, digits = 4)
pc2 <- format(pov[2]*100, digits = 4)
df_out <- as.data.frame(df_pca$x)
p<-ggplot(df_out,aes(x=PC1,y=PC2 ))
p<-p+geom_point() +
  labs(x = paste0('PC1 (',pc1,'% explained var)'), 
       y = paste0('PC2 (',pc2,'% explained var)'), 
       title = 'Expression Level (TPM) of the Genes for each sample (click on the dot to check the samples)') 
p1 <- ggplotly(p) 
m <- list(l = 50, r = 50, b = 150, t = 100, pad = 4)
p1 <- style(p1, text = rownames(file1) , hoverinfo="text") %>%
  layout(autosize = F, width = 1000, height = 800, margin = m)

return(p1)
}