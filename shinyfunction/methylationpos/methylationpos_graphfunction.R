
heatmap_fun <- function(file, title){
rownames(file) <- file$pos
file <- file[,-1]
file1 <- t(file)[,1:101]

group <- read.csv2('/Users/wenliang/Documents/thesis/WGBS/results/groups.csv', stringsAsFactors = FALSE)

group$tumor <- sub('-', '.', group$tumor)
group$control <- sub('-', '.', group$control)

groupping <- vector()
for (name in rownames(file1)){
  if (name %in% group$tumor) {
    groupping <- c(groupping, 'red')
  }
  if (name %in% group$control) {
    groupping <- c(groupping, 'blue')
  }
}

#col = colorRampPalette(c('blue', 'yellow', 'red'))(30)
#breaks = seq(from=0, to=1, length.out=31)
#lg_breaks <- c(0,0.2,0.4,0.6,0.8,1)
#lg_labels <- c('0', '20%', '40%', '60%', '80%', '100%')
#pheatmap(file1, cluster_cols = FALSE, color = col, breaks = breaks, border_color = NA,
#         legend_labels = lg_labels, legend_breaks = lg_breaks, fontsize_col = 11,
#         fontsize_row = 5, cellheight = 5, main = title, fontsize = 20)
ht = Heatmap(file1, cluster_columns = FALSE, col = colorRamp2(c(0, 0.5, 1), c('blue', 'yellow', 'red')),
    column_title = paste0(title, '  (tumor groups: red; control groups: blue)'),
    column_title_gp = gpar(fontsize = 16, fontface = "bold"),
    heatmap_legend_param = list(title= "methylation level", legend_width = unit(10, "cm"),
                                title_gp = gpar(fontsize = 15), legend_direction = "horizontal",
                                title_position = "lefttop"),
    row_names_gp = gpar(fontsize = 10, col = groupping), column_names_gp = gpar(fontsize = 10))
draw(ht, heatmap_legend_side = "bottom")
}
