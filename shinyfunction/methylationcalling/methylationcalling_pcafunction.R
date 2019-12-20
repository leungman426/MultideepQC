
m <- list(l = 50, r = 50, b = 150, t = 100, pad = 4)
# PCA
pca_fun <- function(file, tle){
file <- file[,-1]

# remove the samples with too many NAs
x = 1
xs = vector()
names <- vector()
for (name in colnames(file)){
  if (sum(is.na(file[,name])) > 0.75*length(file[,name])){
    names <- c(names, name)
    xs <- c(xs, x)
  }
  x = x+1
}
file <- file[,-xs]

# remove the cpg sites with any NA
file <- na.omit(file)
file1 <- data.frame(t(file))
file2 <- group_fun(file1)
df_pca <- prcomp(file2[,-length(colnames(file2))])

pov <- df_pca$sdev^2/sum(df_pca$sdev^2) # proportion of variance 
pc1 <- format(pov[1]*100, digits = 4)
pc2 <- format(pov[2]*100, digits = 4)
df_out <- as.data.frame(df_pca$x)
p<-ggplot(df_out,aes(x=PC1,y=PC2 ))
p<-p+geom_point(aes(color = factor(file2[,'group']))) +
   labs(title = tle, x = paste0('PC1 (',pc1,'% explained var)'), 
        y = paste0('PC2 (',pc2,'% explained var)')) +
    scale_color_discrete(name="groups")

#  because more than 80% CpG sites have not any read
p1 <- ggplotly(p) 
p1 <- style(p1, text = rownames(file2) , hoverinfo="text") %>%
  layout(autosize = F, width = 1000, height = 800, margin = m)
 
return(p1)

}
