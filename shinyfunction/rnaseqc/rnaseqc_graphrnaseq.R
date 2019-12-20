

graph_rnaseq <- function(file1, title1) {
# "levels" which ggplot uses to determine the order things should appear in the plot
file1$samples <- factor(file1[,'samples'], levels = file1[,'samples'])

# key will be stored as a factor, which preserves the original ordering of the columns
df <- gather(file1, key = 'variables', value = 'value', -samples, factor_key = TRUE)
p <- ggplot(df, aes(x=samples, y=value)) +
     geom_col(aes(fill = variables)) + 
     theme(axis.text.x = element_text(angle = 90)) +
     labs(y = "read count (%)", title = title1)

m <- list(
  l = 50,
  r = 50,
  b = 120,
  t = 100,
  pad = 4
)
p1 <- ggplotly(p) %>%
  layout(autosize = F, width = 1000, height = 800, margin = m)

return(p1)
}

