source('/home/liangwe/tool/function/methylationcallingfunction3.R')
otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/home/liangwe/tool/data/'

# path: 'data3/merged/', 'data4/merged/', 'data6/merged'
# par: 'islands', 'shores', 'all'
methylationcalling_merged(otp_path, path, 'islands_merged/', 'islands')
methylationcalling_merged(otp_path, path, 'shores_merged/', 'shores')
methylationcalling_merged(otp_path, path, 'all_merged/', 'all')
# can delete the files for each sample
