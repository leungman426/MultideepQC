tabItem(tabName = "introduction", align = "center",
        
        fluidRow( style="width:80%;",
                  tags$div(class="header", checked=NA,
                           tags$br(), 
                           tags$p("MultiDeep QC", style ='font-family:Chalkduster;
                                                            font-size:200%'),
                           tags$p("An Integrated And Multiple-Sample Quality Control Tool For Next Generation Sequencing"), 
                                  style = 'font-family:Comic Sans MS;
                                           font-size:200%'),
                           tags$br(), 
                           tags$br(), 
                           tags$p('The One Touch Pipeline (OTP) is an automated platform for managing and processing Next Generation Sequencing (NGS) data.
                                  Nowadays, most of the enormous data flow produced within the DKFZ is processed automatically via OTP.
                                  However, those QC results are generated in per-sample bias data files, which require users to visulise them sample by sample. 
                                  It not only increases the workloads, but also makes users difficult to identify the global trends, batch effects and outlier samples.',
                                  style = 'font-family:Comic Sans MS;
                                           font-size:150%'),
                           tags$br(), 
                           tags$br(), 
                            tags$b('MultiDeep QC summeries the data files from OTP, generates the multiple-sample files and 
                                       creates the intergrated QC reports with visualisation across all samples. 
                                   Currently, this tool can be applied to Whole Genome Bisulfite Sequencing (WGBS) and RNA-Sequencing (RNAseq)',
                                   style = 'font-family:Comic Sans MS;
                                             font-size:180%')
        )                  
)
