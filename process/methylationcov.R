library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/tool/data/'
source('/function/methylationcov_function.R')
starttime <- Sys.time()


methylationcov(otp_path, path)

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'methylationcov_info.txt'))
