flag_file <- function(path, par) {
file <- read.csv2(paste0(path, par, '.csv'))
if (par != 'flagstat_rna') {
colnames(file) <- c('samples', 'total reads', 'total(failed)', 
                    'duplicates reads',                                                      
                    "duplicates (failed)",                                              
                    "mapped reads",                                                          
                    "mapped (failed)",                                                  
                    "paired in sequencing",                                           
                    "paired in sequencing (failed)",                                     
                    "read1",                                                          
                    "read1 (failed)",                                                   
                    "read2",                                                           
                    "read2 (failed)",                                                   
                    "properly paired",                                                
                    "properly paired (failed)",                                         
                    "with itself and mate mapped",                                    
                    "with itself and mate mapped (failed)",                             
                    "singletons",                                                      
                    "singletons (failed)",                                               
                    "with mate mapped to a different chr",                            
                    "with mate mapped to a different chr (failed)",                     
                    "with mate mapped to a different chr (mapQ>5)",        
                    "with mate mapped to a different chr (mapQ>5, failed)")
} else {
  colnames(file) <- c('samples', 'total', 'total(failed)',   
    'secondary', 'secondary (failed)', 'supplementary', 'supplementary (failed)',
    'duplicates reads', "duplicates (failed)",                                              
    "mapped reads",                                                          
    "mapped (failed)",                                                  
    "paired in sequencing",                                           
    "paired in sequencing (failed)",                                     
    "read1",                                                          
    "read1 (failed)",                                                   
    "read2",                                                           
    "read2 (failed)",                                                   
    "properly paired",                                                
    "properly paired (failed)",                                         
    "with itself and mate mapped",                                    
    "with itself and mate mapped (failed)",                             
    "singletons",                                                      
    "singletons (failed)",                                               
    "with mate mapped to a different chromosomes",                            
    "with mate mapped to a different chromosomes (failed)",                     
    "with mate mapped to a different chromosomes (mapQ>5)",        
    "with mate mapped to a different chromosomes (mapQ>5, failed)"
  )
}

return(file)
}


