

heatmap_rna <- function(path, diffgene) {
if (diffgene == 'topgene_exp.csv') {
  tle <- 'High Expression Genes'
} else if (diffgene == 'midgene_exp.csv') {
  tle <- 'Intermediate Expression Genes'
} else { tle <- 'Low Expression Genes' }
  
file <- read.csv2(paste0(path, diffgene),
                  sep = ',', stringsAsFactors = FALSE)
file <- file[,-1][c(1:2000),]
file1 <- data.frame(apply(file[,-1], 2, as.numeric))
exp <- function(list){
  list1 <- log10(list+1)
  return(list1)
}
file1 <- data.frame(apply(file1, 2, exp))
rownames(file1) <- file[,'gene']
file2 <- t(file1)

a <- min(file1)
b <- max(file1)

# for 2000 genes
ht = Heatmap(file2, 
             col = colorRamp2(seq(a, b, by = (b-a)/4), c('blue',"green", "yellow", "red",'black')),
             column_title = paste0('Expression Level (TPM) of the frist 2000 genes  ',tle), 
             show_column_names = FALSE,
             column_title_gp = gpar(fontsize = 16, fontface = "bold"),
             heatmap_legend_param = list(title= 'Expression level (log10)', legend_width = unit(10, "cm"),
                                         title_gp = gpar(fontsize = 15), legend_direction = "horizontal",
                                         title_position = "lefttop"),
             row_names_gp = gpar(fontsize = 10))
draw(ht, heatmap_legend_side = "bottom")
}
