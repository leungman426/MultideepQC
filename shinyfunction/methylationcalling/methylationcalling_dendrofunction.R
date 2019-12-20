

m <- list(l = 50, r = 50, b = 100, t = 100, pad = 4)

# clustering
dendro_fun <- function(file, tle){
file <- file[,-1]
file <- data.frame(t(file))
file1 <- group_fun(file)
hc <- hclust(dist(file), "ave")
hcdata <- dendro_data(hc, type="rectangle")
p <- ggplot() +
  geom_segment(data=segment(hcdata), aes(x=x, y=y, xend=xend, yend=yend)) +
  geom_text(data=label(hcdata), aes(x=x, y=y, label=label, color = factor(file1[,'group'])), 
            nudge_y=1.2, size=2, fontface = 'bold') +
  labs(title = tle, x = '', y = '') +
  coord_flip() +
  scale_y_reverse(expand=c(0.45, 0)) +
  scale_color_discrete(name="groups") +
  guides(fill = guide_legend(title = 'group', title.position = "left"))

p1 <- ggplotly(p) %>%
  layout(autosize = F, width = 1000, height = 1000, margin = m)

return(p1)

}
