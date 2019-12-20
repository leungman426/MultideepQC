
exp_len <- function(file, xlab1, tle) {

df1 <- gather(file, key = 'GeneLength', value = 'ExpressionLevel', -samples)
df1[,'GeneLength'] <- as.numeric(df1[,'GeneLength'])
df1[,'ExpressionLevel'] <- as.numeric(df1[,'ExpressionLevel'])
genelen <- cut(df1$GeneLength, 30) #, dig.lab = 10)

df1$GeneLength <- genelen

a <- log10(df1[,'ExpressionLevel'])
df2 <- df1[!is.infinite(a),]

p <- ggplot(df2, aes(x = df2[,'GeneLength'], y = log2(df2[,'ExpressionLevel']))) + 
     geom_boxplot() +
     labs(x = xlab1, y = 'Expression Level(log2)', title = tle) +
     theme(axis.text.x = element_text(angle = 90))

m <- list(
  l = 50,
  r = 50,
  b = 400,
  t = 100,
  pad = 4
)
p1 <- ggplotly(p) 
p2 <- style(p1, text = df2[,'samples'] , hoverinfo = "text") %>%
       layout(autosize = F, width = 1000, height = 800, margin = m)

return(p2)
}

