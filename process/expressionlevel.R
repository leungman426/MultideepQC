library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_043/sequencing/rna_sequencing/view-by-pid/'
path <- '/data/'
source('/function/expressionlevel1.R')
source('/function/expressionlevel2.R')
starttime <- Sys.time()

expressionlevel1(otp_path, path)
expressionlevel2(otp_path, path)

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'expressionlevel_info.txt'))
