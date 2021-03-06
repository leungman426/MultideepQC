library(pryr)
library(stringr)
otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/data/'
source('/function/flatstatfunction.R')
starttime <- Sys.time()

df_flagstat(otp_path, path)

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'flagstat_info.txt'))
