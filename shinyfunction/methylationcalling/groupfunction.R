# file: rownames are samples
group_fun <- function(file){
group <- read.csv2('/Users/wenliang/Documents/thesis/WGBS/results/groups.csv', stringsAsFactors = FALSE)

group$tumor <- sub('-', '.', group$tumor)
group$control <- sub('-', '.', group$control)

groupping <- vector()
for (name in rownames(file)){
   if (name %in% group$tumor) {
      groupping <- c(groupping, 'tumor')
   }
   if (name %in% group$control) {
      groupping <- c(groupping, 'control')
    }
}

file['group'] <- groupping
return(file)
}