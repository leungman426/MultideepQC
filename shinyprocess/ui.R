
ui <- dashboardPage(
skin = "black",
dashboardHeader(title = "MultiDeep QC"),
  
dashboardSidebar(width = 320,
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction"),
      menuItem('Whole Genome Bisulfite Sequencing (WGBS)', tabName = 'wgbs', startExpanded = TRUE,
          menuItem('Guidence', tabName = 'guide_wgbs'),
          menuItem('General Coverage', tabName = 'cov'),
          menuItem("Flagstat QC values", tabName = "generalqc"),
          menuItem('Global Methylation', tabName = 'globalmethy'),
          menuItem('Methylation for Read Position', tabName = 'methy_pos'),
          menuItem('Distribution of CG/CH Coverage', tabName = 'methy_cov'),
          menuItem('Methylation for BaseQ Scores', tabName = 'methy_baseq'),
          menuItem('Methylation Profiles' , startExpanded = TRUE,
               menuSubItem('Methylation Distribution', tabName = 'methy_freq'),
               menuSubItem('Clustering Analysis', tabName = 'subgroup'))),
         menuItem('RNA Sequencing (RNA-Seq)', tabName = 'rnaseq', startExpanded = TRUE,
              menuItem('Guidence', tabName = 'guide_rna'),
              menuItem('Flagstat QC values', tabName = 'flag_rna'),
              menuItem('RNAseQC Read Count Metrics', startExpanded = TRUE,
                  menuSubItem('Total Reads', tabName = 'total'),
                  menuSubItem('Mapped Reads', tabName = 'mapped'),
                  menuSubItem('Transcripts Associated Reads', tabName = 'transrcipts'),
                  menuSubItem('Strand Specificity', tabName = 'strand')),
              menuItem('Expression Level', startExpanded = TRUE,
                  menuSubItem('Expression Level for Transcripts', tabName = 'explevel'),
                  menuSubItem('Expression Level vs Gene/exon Length', tabName = 'genelength'),
                  menuSubItem('Clustering Analysis', tabName = 'differexplevel')
          ))
)),

dashboardBody( 
  tabItems(
   source(paste0(path, '/intro.R'), local = TRUE)$value,
   
   source(paste0(path, '/wgbs.R'), local = TRUE)$value,

      tabItem(tabName = 'generalqc',
         fluidRow(
                 tags$div(
                      tags$p('Users can choose either flagstat (13 FLAG read counts) or flagtat-extend (7 FLAG read counts).',
                             style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                      tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                      tags$p('1. Table listing FLAG read counts for all samples',
                             style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                      tags$p('2. The FLAG read counts are shown in box plots across samples',
                             style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                      tags$p('3. Check the outlier samples in the box plots for each FLAG read count',
                             style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
                    )
                 
          ),
         fluidRow(box(width = 12, 
           radioButtons(width = '120%', inline = TRUE, 'par_flag', tags$p('select one flagstat report', 
                                                                    style = 'font-family:Comic Sans MS;font-size:120%'),
                               choices = list('Flagstat' = 'flagstat', 'Flagstat Extend' = 'flagstat_extend'))),
                tabBox(width = 12,
                      
                       tabPanel('Plot', plotlyOutput('flag_plot', width = 1000, height = 2300)),
                       tabPanel('Table', DTOutput('flag_table')),
                       tabPanel('Outliers Table', tableOutput('flag_outlierstable'))
                )
         )
      ),
  ##################################################################################################
      tabItem(tabName = 'cov',
           fluidRow(   
             tags$div(
               tags$p('User can choose 16 coverage parameter to investigate. 
                      For each coverage paramter, 
                      users can choose mean/sum/median coverage of all chromsomes or coverage by chromosomes',
                      style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
               tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
               tags$p('1. The table listing coverage of all samples.',
                      style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
               tags$p('2. Box plots displying coverage of all samples (check the outlier samples in the box plot).',
                      style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
               )),
           fluidRow(
             box(width = 12, 
             column(width = 3, 
                  tags$div(
                  tags$p('sum/mean/median coverage', style = 'font-family:Comic Sans MS;
                          font-size:120%'),
                  tags$p('coverage by chromosomes', style = 'font-family:Comic Sans MS;
                          font-size:120%')
                   ),
                   selectInput('par_cov', '',
                               choices = list('Mean' = 'mean', 'Sum' = 'sum','Median' = 'median',
                                               'By Chromosomes' = 'chr'))
                  ),
             column(width = 3,
                   selectInput('var_cov', tags$p('Coverage Parameters', style = 'font-family:Comic Sans MS;
                          font-size:120%'),
                           choices = list("coverage" = "coverage.QC.bases",
                                          'Not N coverage' = 'genome_w.o_N.coverage.QC.bases',
                                          'QC covrage/total coverage' = 'X.QC.bases..total.bases',
                                          'QC covrage/total not N coverage' = 'X.QC.bases..total.not_N.bases',
                                          '% incorrect PE orientation' = 'X.incorrect.PE.orientation',
                                          'incorrect proper pair' = 'X.incorrect.proper.pair',
                                          "Read 1 mapq = 0" = 'mapq.0.read1',
                                          'Read 1 mapq > 0 base quality median < base cutoff' = 'mapq.0.BaseQualityMedian.basequalCutoff.read1',
                                          'Read 1 mapq > 0 base quality median > base cutoff' = 'mapq.0.BaseQualityMedian..basequalCutoff.read1',
                                          'Read 1 mapq > 0 read length < min length' = 'mapq.0.readlength.minlength.read1',
                                          'Read 1 duplicates' = 'X.duplicates.read1..excluded.from.coverage.analysis.',
                                          "Read 2 mapq = 0" = 'mapq.0.read2',
                                          'Read 2 mapq > 0 base quality median < base cutoff' = 'mapq.0.BaseQualityMedian.basequalCutoff.read2',
                                          'Read 2 mapq > 0 base quality median > base cutoff' = 'mapq.0.BaseQualityMedian..basequalCutoff.read2',
                                          'Read 2 mapq > 0 read length < min length' = 'mapq.0.readlength.minlength.read2',
                                          'Read 2 duplicates' = 'X.duplicates.read2..excluded.from.coverage.analysis.'),
                           selected = 1)
               )
           )
           ),
           fluidRow(
                tabBox(width = 12, height = '1200px',
                      
                       tabPanel('Plot',  actionButton("outliersButton", "Check Outliers"),
                                         textOutput('txt_cov'),
                                         plotlyOutput('cov_plot'),
                                         br(), br(), br(), br(), br(),
                                         br(), br(), br(), br(), br(),
                                         br(), br(), br(), br(), br(),
                                         tableOutput('cov_outliers')),
                       tabPanel('Table', DTOutput('cov_table'))
                 )
            )
           ),
##################################################################################################

       tabItem(tabName = 'globalmethy',
           fluidRow(   
             tags$div(
               tags$p('For the global methylation level, users can investigate the number of methylated (unmethylated) 
                      cytosines in both CG and CH sites. Plus the methylation ratio in CG and CH sites.',
                      style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
               tags$p('Users can choose either mean/sum/median global methylation level of all chromosomes or the global methylaiton 
                      level in each chromosome.', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
               tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
               tags$p('1. Table listing the global methylation level of all samples',
                      style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
               tags$p('2. Box plots displaying the global methylation level across samples (check the outlier samples in the boxplot).',
                      style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
             )
           ),
           fluidRow(
             box(width = 12,
              column(width = 5, tags$div(tags$p('sum/mean/median global methylation level', 
                                       style = 'font-family:Comic Sans MS;font-size:120%'),
                              tags$p('global methylation by chromosomes', style = 'font-family:Comic Sans MS;
                          font-size:120%')),
                   selectInput('par_globalmethy', '',
                               choices = list('Sum' = 'sum', 'Mean' = 'mean', 'Median' = 'median',
                                             'By Chromosome' = 'chr'))
                   ),
              column(width = 4,
                   selectInput('var_globalmethy', tags$p('global methylation parameter',
                                               style = 'font-family:Comic Sans MS;font-size:120%'),
                           choices = list(  'CG sites with unmethylated C' = 'CG_C_globalmethylation',
                                            'CG sites with methylated C' = 'CG_mC_globalmethylation',
                                            'CG sites with methylated C ratio' = 'CG_ratio_globalmethylation',
                                            'CH sites with unmethylated C' = 'CH_C_globalmethylation',
                                            'CH sites with methylated C' = 'CH_mC_globalmethylation',
                                            'CH sites with methylated C ratio' = 'CH_ratio_globalmethylation'),
                           selected = 1)
                   )
             )  
           ),
           fluidRow(
                tabBox(width = 12, height = '1200px',
                      
                       tabPanel('Plot',   actionButton("outliersButton_globalmethy", "Check Outliers"),
                                          plotlyOutput('globalmethy_plot'),
                                          br(), br(), br(), br(), br(),
                                          br(), br(), br(), br(), br(), br(), br(),
                                          br(), br(), br(), br(),
                                          tableOutput('globalmethy_outliers')),
                                tabPanel('Table',  DTOutput('globalmethy_table'))
                                 
                      
                 )
           )
       ),
##################################################################################################

      tabItem(tabName = 'methy_pos',
         fluidRow( 
           tags$div(
             tags$p('This tool displays the average methylation level in each read position (M-bias plot). Heatmap is used to display
                    the M-bias plot across samples', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('Users can choose mean/median methylation level of all chromosomes or the methylation level in each chromosome.
                    Plus, users can choose either mate1 read or mate2 read to look into',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('In the table, users can group the read positions and get the mean methylation level.',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
             )
         ),
         fluidRow(
             box(width = 12, 
                 column(width = 5, 
                   tags$div(tags$p('mean/median methylation level for read positions', 
                                  style = 'font-family:Comic Sans MS;font-size:120%'),
                          tags$p('methylation level of each chromosome',
                                 style = 'font-family:Comic Sans MS;font-size:120%')), 
                selectInput('par_pos', '',
                            choices = list('Mean' = 'mean', 'Median' = 'median', 'chr 1' = 1,
                            'chr 2' = 2, 'chr 3' = 3, 'chr 4' = 4, 'chr 5' = 5, 'chr 6' = 6, 'chr 7' = 7, 'chr 8' = 8,
                            'chr 9' = 9, 'chr 10' = 10, 'chr 11' = 11, 'chr 12' = 12, 'chr 13' = 13, 'chr 14' = 14, 'chr 15' = 15,
                            'chr 16' = 16, 'chr 17' = 17, 'chr 18' = 18, 'chr 19' = 19, 'chr 20' = 20, 'chr 21' = 21, 'chr 22' = 22,
                            'chr X' = 'X', 'chr Y' = 'Y'))),
              column(width = 3,
                 selectInput('mate_pos', tags$p('select mate1 or mate2',style = 'font-family:Comic Sans MS;font-size:120%'),
                                                choices = list('Mate 1' = 'mate1', 'Mate 2' = 'mate2')))
          )),
           fluidRow(
              tabBox(width = 12, height = 2000,
                     tabPanel('Heatmap & Clustering', plotOutput('pos_plot', width = 1000, height = 1000)),
                     tabPanel('Table', textOutput("txt_pos"),
                                                 htmltools::tags$head(htmltools::tags$style("#txt_pos{
                                                                       font-size: 20px;
                                                                       font-style: bold;}")),
                                      numericInput("bin1", "from position 1 to position A", 10),
                                      numericInput("bin2", "from Y to postion position B", 90),
                                      DTOutput('pos_table'))
              )
           )
      ),
##################################################################################################
      tabItem(tabName = 'methy_cov',
          fluidRow(
            tags$div(
              tags$p('The tool checks the distribtion of CG and CH coverage by ploting the number of the CG/CH sites against 
                      each coverage value.', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
              tags$p('Users can choose either CG or CH sites to look into. 
                     Plus, user can choose mean/median number of CG/CH sites of all chromosomes or total number in each chromosome.',
                     style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
              tags$b('report', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
              tags$p('1. Table listing the number of CG/CH sites of 1-200 coverage value', 
                     style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
              tags$p('2. Line plot displaying the number of CG/CH sites against 1-200 coverage value.',
                     style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
            )
          ),
          fluidRow(
            box(width = 12, 
              column(width = 4,
                 tags$div(tags$p('mean/median CG/CH sites', style = 'font-family:Comic Sans MS;font-size:120%'),
                  tags$p('CG/CH sites by chromosomes', style = 'font-family:Comic Sans MS;font-size:120%')),
                  selectInput('par_methycov', '',
                            choices = list('Mean' = 'mean', 'Median' = 'median', 'chr 1' = 1,
                            'chr 2' = 2, 'chr 3' = 3, 'chr 4' = 4, 'chr 5' = 5, 'chr 6' = 6, 'chr 7' = 7, 'chr 8' = 8,
                            'chr 9' = 9, 'chr 10' = 10, 'chr 11' = 11, 'chr 12' = 12, 'chr 13' = 13, 'chr 14' = 14, 'chr 15' = 15,
                            'chr 16' = 16, 'chr 17' = 17, 'chr 18' = 18, 'chr 19' = 19, 'chr 20' = 20, 'chr 21' = 21, 'chr 22' = 22,
                            'chr X' = 'X', 'chr Y' = 'Y'))),
                   column(width = 4, selectInput('var_methycov', tags$p('select CG or CH site', style = 'font-family:Comic Sans MS;font-size:120%'),
                                                                     choices = list('CG sites' = 'CG', 'CH sites' = 'CH')))
            )
          ),
          fluidRow(
              tabBox(width = 12, height = 1000, 
                    
                     tabPanel( 'Plot', plotlyOutput('methycov_plot', width = 1200, height = 800)),
                     tabPanel( 'Table', DTOutput('methycov_table'))
              )
          )
      ),
######################################################################################################
      tabItem(tabName = 'methy_baseq',
         fluidRow(
           tags$div(
             tags$p('The tool checks the methylation level at CG sits against the base Q scores (0-41)',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('Users can choose mean/median methylation level of all chromosomes or methylation level in each chromosome. 
                    Plus, users can choose either mate1 read or mate2 read to look into.',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
             tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('1. Table listing the methylation level at each base Q score for all samples.',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('2. Point plot displying the methylation level at each base Q score across samples.',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('3. Violin plot displaying the distribution of the methylation level of all samples at each base Q score',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
           )
         ),
         fluidRow(
             box(width = 12, 
               column(width = 5,
                 tags$div(tags$p('mean/median methylation level', style = 'font-family:Comic Sans MS;font-size:120%'),
                          tags$p('methylation level by chromosomes', style = 'font-family:Comic Sans MS;font-size:120%')),
                selectInput('par_baseq', '',
                            choices = list('Mean' = 'mean', 'Median' = 'median', 'chr 1' = 1,
                            'chr 2' = 2, 'chr 3' = 3, 'chr 4' = 4, 'chr 5' = 5, 'chr 6' = 6, 'chr 7' = 7, 'chr 8' = 8,
                            'chr 9' = 9, 'chr 10' = 10, 'chr 11' = 11, 'chr 12' = 12, 'chr 13' = 13, 'chr 14' = 14, 'chr 15' = 15,
                            'chr 16' = 16, 'chr 17' = 17, 'chr 18' = 18, 'chr 19' = 19, 'chr 20' = 20, 'chr 21' = 21, 'chr 22' = 22,
                            'chr X' = 'X', 'chr Y' = 'Y'))),
              column(width = 6, 
                     selectInput('mate_baseq', tags$p('select mate1 or mate2', 
                                                              style = 'font-family:Comic Sans MS;font-size:120%'),
                                         choices = list('Mate 1' = 'mate1', 'Mate 2' = 'mate2')))
             )
          ),
           fluidRow(
              tabBox(width = 12, height = 1500,
                    
                     tabPanel( 'Plot',
                     fluidRow(plotlyOutput('baseq_plot', width = 1200, height = 650)),
                     fluidRow(plotlyOutput('baseq_plot1', width = 1200, height = 650))),
                     tabPanel( 'Table', DTOutput('baseq_table'))
              )
           )
      ),
 ######################################################################################################
      tabItem(tabName = 'methy_freq',
         fluidRow(
           tags$div(
             tags$p('The tool investigates the distribution of methylation level in all regions, CpG islands and CpG shores',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('Users can choose the specific chromosome or all chromosomes to look into. Plus, users can 
                    choose plus strand or minus strand.', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
             tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
             tags$p('Line plot displaying the distribution of CpG methylation level.',
                    style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
           )
         ),
         fluidRow(
             box(
                selectInput('sites_freq', tags$p('select the CpG sites in all regions/CpG islands/CGI shores',
                                                 style = 'font-family:Comic Sans MS;font-size:120%'),
                                               choices = list('CpG islands' = 'islands',
                                                              'CGI shores' = 'shores',
                                                              'All CpG sites' = 'all')),
                selectInput('par_freq', tags$p('methylation level of all chromosomes or by chromosomes',
                                               style = 'font-family:Comic Sans MS;font-size:120%'),
                            choices = list('chr 1' = 1,
                            'chr 2' = 2, 'chr 3' = 3, 'chr 4' = 4, 'chr 5' = 5, 'chr 6' = 6, 'chr 7' = 7, 'chr 8' = 8,
                            'chr 9' = 9, 'chr 10' = 10, 'chr 11' = 11, 'chr 12' = 12, 'chr 13' = 13, 'chr 14' = 14, 'chr 15' = 15,
                            'chr 16' = 16, 'chr 17' = 17, 'chr 18' = 18, 'chr 19' = 19, 'chr 20' = 20, 'chr 21' = 21, 'chr 22' = 22,
                            'chr X' = 'X', 'chr Y' = 'Y', 'all chromosomes' = 'allchr'), selected = 'allchr')),
                box(width = 6,
                    selectInput('strand_freq', tags$p('select the plus strand or minus strand', 
                                                      style = 'font-family:Comic Sans MS;font-size:120%'),
                                                      choices = list('plus (+) strand' = 'plus', 'minus (-) strand' = 'minus')))
          ),
           fluidRow(
              tabBox(width = 12, height = 1000,
                     tabPanel( 'Plot', plotlyOutput('freq_plot', width = 1150, height =650))
              )
           )
      ),
######################################################################################################
      tabItem(tabName = 'subgroup',
              fluidRow(
                tags$div(
                  tags$p('The tool perfoms unsupervised sample clustering based on the methylation level via PCA and dendrogram.',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$p('Users can choose CpG sites in all reagions, CpG islands or CGI shores and either plus strand or minus strand to 
                         look into. Plus, users can check the methylation level in specific chromosome or in all chromosomes',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$p('1. PCA', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$p('2. Dendrogram', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%') 
                )
              ),
              fluidRow(
                box(width = 12,
                  column(width = 6, 
                         selectInput('sites_subgroup', 
                              tags$p('select the CpG sites from CpG in all regions/CpG islands/CGI shores',
                                     style = 'font-family:Comic Sans MS;font-size:120%'),
                                                  choices = list('CpG islands' = 'islands',
                                                               'CGI shores' = 'shores',
                                                               'All CpG sites' = 'all')),
                  selectInput('par_subgroup', tags$p('methylation level of all chromoseoms or by chromosomes',
                                                     style = 'font-family:Comic Sans MS;font-size:120%'),
                              choices = list('chr 1' = 1,
                                             'chr 2' = 2, 'chr 3' = 3, 'chr 4' = 4, 'chr 5' = 5, 'chr 6' = 6, 'chr 7' = 7, 'chr 8' = 8,
                                             'chr 9' = 9, 'chr 10' = 10, 'chr 11' = 11, 'chr 12' = 12, 'chr 13' = 13, 'chr 14' = 14, 'chr 15' = 15,
                                             'chr 16' = 16, 'chr 17' = 17, 'chr 18' = 18, 'chr 19' = 19, 'chr 20' = 20, 'chr 21' = 21, 'chr 22' = 22,
                                             'chr X' = 'X', 'chr Y' = 'Y', 'all chromosomes' = 'allchr'), selected = 'allchr')),
                 column(width = 6, selectInput('strand_subgroup', 'select the plus strand/ minus strand', choices = list('plus (+) strand' = 'plus', 'minus (-) strand' = 'minus')))
              )),
              fluidRow(
                   tabBox(width = 12, height = 2000,
                          tabPanel( 'Plot PCA',  # , width = 1150, height =650
                                    textOutput("naomit"),
                                    textOutput('txt_pca'),
                                    plotlyOutput('plot_pca')
                                    ),
                          tabPanel( 'Plot Dendrogram', plotlyOutput('plot_dendro', width = 1150, height =1000))
                    ) 
              )
      ),

######################################################################################################
       tabItem(
         tabName = 'guide_rna',
         source(paste0(path, '/intro_rnaseq.R'), local = TRUE)$value
        ),
       tabItem(tabName = 'flag_rna',
               fluidRow(
                 tags$div(
                   tags$p('The tool provides the flagstat QC report (15 FLAG read counts).',
                             style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                   tags$p('1. Table listing all FLAG read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('2. Box plots displaying all FLAG read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('3. check the outlier samples in the box plots of each FLAG read count',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
                 )
               ),
               fluidRow(
               tabBox(width = 12, 
                                
                                tabPanel( 'Plot', plotlyOutput('flagrna_plot', width = 1000, height = 2000)),
                                tabPanel( 'Outliers Table', tableOutput('flagrna_outlierstable')),
                      tabPanel( 'Table', DTOutput('flagrna_table'))
                ))

       ),
       tabItem(tabName = 'total',
               fluidRow(
                 tags$div(
                   tags$p('The tool shows the total read count in the RNASeQC read count metrics',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                   tags$p('1. Table listing the total read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('2. Box plots displaying the total read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('3. check the outlier samples in the box plots of total read count values',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('4. Box plot displaying the rRNA mapping ratio across samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
                 )
               ),
               fluidRow(
                tabBox(width = 12, 
                      
                      tabPanel('Plot', plotlyOutput('plot_total', width = 1000, height = 2300)),
                      tabPanel('Table', DTOutput('table_total')),
                      tabPanel('Outliers', tableOutput('outliers_total')),
                      tabPanel('rRNA rate', plotlyOutput('rrnarate', width = 500, height = 600))
                ))
        ),
       tabItem(tabName = 'mapped',
               fluidRow(
                 tags$div(
                 tags$p('The tool shows the mapped read count in the RNASeQC read count metrics',
                        style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                 tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                 tags$p('1. Table listing the mapped read count values for all samples',
                        style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                 tags$p('2. Box plots displaying the mapped read count values for all samples',
                        style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                 tags$p('3. check the outlier samples in the box plots of mapped read count values',
                        style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
               )),
               fluidRow(
                tabBox(width = 12,
                      
                      tabPanel('Plot', plotlyOutput('plot_mapped', width = 1000, height = 2300)),
                      tabPanel('Table', DTOutput('table_mapped')),
                      tabPanel('Outliers', tableOutput('outliers_mapped'))
                ))
        ),
       tabItem(tabName = 'transrcipts',
               fluidRow(
                 tags$div(
                   tags$p('The tool shows the transcript associated read count in the RNASeQC read count metrics',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                   tags$p('1. Table listing the transcript associated read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('2. Box plots displaying the transcript associated read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('3. check the outlier samples in the box plots of transcript associated read count values',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('4. Bar plot displaying the inronic, exonic and intergenic mapping ratio across samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
               )),
               fluidRow(
               tabBox(width = 12, 
                      
                      tabPanel('Plot', plotlyOutput('plot_transcripts', width = 1000, height = 2300)),
                      tabPanel('Table', DTOutput('table_transcripts')),
                      tabPanel('Outliers', tableOutput('outliers_transcripts')),
                      tabPanel('Intronic, Extronic and Intergenic Region Reads', plotlyOutput('genesmapping', width = 1000, height = 800))
                ))
        ),
       tabItem(tabName = 'strand',
               fluidRow(
                 tags$div(
                   tags$p('The tool shows the strand specific read count in the RNASeQC read count metrics',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                   tags$p('1. Table listing the strand specific read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('2. Box plots displaying the strand specific read count values for all samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('3. check the outlier samples in the box plots of strand specific read count values',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                   tags$p('4. Bar plot displaying the End1 and End2 reads sense strand mapping percentage across samples',
                          style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
               )),
               fluidRow(
               tabBox(width = 12,
                     
                      tabPanel('Plot', plotlyOutput('plot_strand', width = 1000, height = 2300)),
                      tabPanel('Table', DTOutput('table_strand')),
                      tabPanel('Outliers', tableOutput('outliers_strand')),
                      tabPanel('End1/2 sense Percentage', 
                               radioButtons('txt_anno', tags$p('library type:',
                                                               style = 'font-family:Comic Sans MS;font-size:120%'),
                                            choices = list('fr-unstranded' = 'unstr',
                                                           'fr-firststrand' = 'firststr',
                                                           'fr-secondstrand' = 'secondstr'),
                                            width = '600px'),
                               textOutput('txt_sense'),
                               plotlyOutput('sensepercentage', width = 1000, height = 800))
                ))
        ),
      tabItem(tabName = 'genelength',
              fluidRow(
                tags$div(
                tags$p('The tool investigates the relationship between gene expression level (TPM) and gene (exon) length.
                       If the sample is non strand specific, the tool chooses TPM to look into. If the sample is 
                       strand specifc, the tool chooses the larger one from TPM-forward and TPM-reverse',
                       style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                tags$p('1. Box plot displaying the gene expression level in each gene length interval',
                       style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                tags$p('2. Box plot displaying the gene expression level in each exon length interval',
                       style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
              )),
              fluidRow(
                box(width = 6, 
                  radioButtons('length', '', inline = TRUE,
                               choices = list('Gene Length' = 'gene_length',
                                              'Exon Length' = 'exon_length')
                               )
                    )
                ),
              fluidRow(box(width = 12,
                plotlyOutput('plot_genelength',width = 1300, height = 800)))
       ),
      tabItem(tabName = 'explevel',
              fluidRow(
                tags$div(
                  tags$p('The tool provides the expression level (TPM) for various kinds of transcripts',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                  tags$p('Box plot displaying the gene expression level of various kinds of transcripts',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%')
              )),
              fluidRow(
                  tabBox(width = 12,
                            tabPanel('Expression Level', plotlyOutput('plot_exp',  width = 1000, height = 1500)),
                            tabPanel('Outliers', tableOutput('outliers_exp'))

             ))
      ),
      tabItem(tabName = 'differexplevel',
              fluidRow(
                tags$div(
                  tags$p('The tool groups the genes into high, intermediates and high expression level genes. In each group,
                         the tool displays the gene expression level (TPM) for all samples in heatmap, Plus, based on the gene
                         expression level, the unsupervised sample clustering is performed via PCA and dendrogram',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$b('result', style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'), 
                  tags$p('1. Heatmap displaying the gene expression level across samples',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$p('2. PCA clusters the samples based on their gene expression level',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  tags$p('2. Dendrogram clusters the samples based on their gene expression level',
                         style = 'font-family:Comic Sans MS;font-size:160%;margin-left:5%'),
                  
                  tags$br(),
                  tags$br(),
                  tags$p('The tool calculates ean expresion level (TPM) of each gene of all samples. 
                          High expression genes are the genes ranking the top 5000; 
                          Intermediate expression level genes are genes ranking the middle 5000;
                          Low expression level genes are genes ranking the bottom 5000',
                          style = 'font-family:Arial;font-size:150%;margin-left:5%')
                  )
                
              ),
            
            fluidRow(
                 tabBox(width = 12,
                        tabPanel('Heatmap & Clutering',
                                radioButtons('diffgene_heatmap', '', inline = TRUE,
                                choices = list('High Expression Level Genes' = 'topgene_exp.csv',
                                               'Middle Expression Level Genes' = 'midgene_exp.csv',
                                               'Low Expression Level Genes' = 'bottomgene_exp.csv')),
                                plotOutput('plot_diffexp', width = 1000, height = 800)),
                        tabPanel('PCA',
                                radioButtons('diffgene_pca', '', inline = TRUE,
                                choices = list('High Expression Level Genes' = 'topgene_exp.csv',
                                               'Intermeidate Expression Level Genes' = 'midgene_exp.csv',
                                               'Low Expression Level Genes' = 'bottomgene_exp.csv')),
                                plotlyOutput('pca_diffexp', width = 1000, height = 800)
                            ),
                        tabPanel('Dendrogram',
                                radioButtons('diffgene_dendro', '', inline = TRUE,
                                choices = list('High Expression Level Genes' = 'topgene_exp.csv',
                                               'Intermediate Expression Level Genes' = 'midgene_exp.csv',
                                                'Low Expression Level Genes' = 'bottomgene_exp.csv')),
                                plotOutput('dendro_diffexp', width = 1000, height = 500)
                        )
                 )
            )
      )
 ))
)


