


# title: title for the boxplot
# value: annotat the value

graph_flag <- function(file1, width, height, title) {

m <- list(l = 60, r = 50, b = 100, t = 100, pad = 4)
df <- gather(file1, key = 'var', value = value, -samples)

p <- ggplot(data = df, aes(factor(1), value, label = samples)) +
            geom_boxplot(outlier.size = 0.4) +
            geom_point(cex = 0.5) +
            facet_wrap(var~., scales = "free", ncol = 3)+
            theme(axis.text.x = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            # panel.spacing.y = unit(0.1, "lines"), panel.spacing.x = unit(0.1, "lines"),
            strip.background = element_rect(margin(t = 0, r = 0, b = 0, l = 0, unit = "cm")),
            panel.spacing.y  = unit(0.01, 'lines')) +
            labs(title = title)


p1 <- ggplotly(p) %>%
            layout(autosize = FALSE, width = width, height = height, margin = m)

# p2 <- style(p1, text = paste0(df[,'samples'], ' read counts:', df[,"value"]), hoverinfo = "text")

return(p1)

}
