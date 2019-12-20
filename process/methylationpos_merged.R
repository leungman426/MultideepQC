library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/tool/data/'
source('/function/mergefunction.R')
starttime <- Sys.time()

dir.create(paste0(path, 'methylationpos_merged'))
filepattern <- c('position_mate1_CG_mC_ratio.csv', 'position_mate2_CG_mC_ratio.csv')

merge_function(path, 'methylationpos_merged/', 1,125, filepattern)


mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'methylationposmerged_info.txt'))
