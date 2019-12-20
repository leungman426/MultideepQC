

groupreadpos <- function(file, bin1, bin2) {
a <- bin1
b <- bin2
file1 <- file[seq(1,a),]
df1 <- data.frame(apply(file1[,-1], 2, mean))
colnames(df1) <- 'mean methylation level for postion 1 to A'
file2 <- file[seq(a+1,b),]
df2<- data.frame(apply(file2[,-1], 2, mean))
colnames(df2) <- 'mean methylation level for postion A to B'
file3 <- file[seq(b+1,101),]
df3 <- data.frame(apply(file3[,-1], 2, mean))
colnames(df3) <- 'mean methylation level for postion B to 101'
df <- cbind(df1, df2, df3)
return(df)
}
