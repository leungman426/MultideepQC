library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/home/liangwe/tool/data/'
source('/home/liangwe/tool/function/mergefunction.R')
starttime <- Sys.time()

dir.create(paste0(path, 'methylationcov_merged/'))
filepattern <- c('cov_CG.csv', 'cov_CH.csv')
merge_function(path, 'methylationcov_merged/', 1,200, filepattern)

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'methylationcovmerged_info.txt'))

