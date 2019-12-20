library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/tool/data/'
source('/function/methylationposfunction.R')
starttime <- Sys.time()

methylation_pos(otp_path, path)

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'methylationpos_info.txt'))
