
library(pryr)
library(data.table)
library(GetoptLong)
library(GenomicRanges)
library(stringr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/data/'
source('/function/methylationcallingfunction1.R')
source('/function/methylationcallingfunction2.R')
source('/function/methylationcallingfunction3.R')
starttime <- Sys.time()


dir.create(paste0(path, 'islands_merged'))
dir.create(paste0(path, 'shores_merged'))
dir.create(paste0(path, 'all_merged'))

cpgoverlap_func(otp_path, path)

combined_fun('all', otp_path, path)
combined_fun('shores', otp_path, path)
combined_fun('islands', otp_path, path)

methylationcalling_merged(otp_path, path, 'islands_merged/', 'islands')
methylationcalling_merged(otp_path, path, 'shores_merged/', 'shores')
methylationcalling_merged(otp_path, path, 'all_merged/', 'all')

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'methylationcalling_info.txt'))
