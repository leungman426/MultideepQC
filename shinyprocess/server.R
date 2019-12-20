
server <- function(input, output){
 
  file_flagstat <- reactive({
    flag_file(path ,input$par_flag)
  })
  file_flagextend <- reactive({
    flagextend_file(path, input$par_flag)
  })
  
  output$flag_plot <- renderPlotly({
    if (input$par_flag == 'flagstat') {
      graph_flag(file_flagstat(), 1000, 2300,
                 'FLAG read counts (% of total reads) across samples (click on the dots to check the samples)')
    } else {graph_flag(file_flagextend(), 1000, 1000,
                       'FLAG read counts (% of total reads) across  sample (click on the dots to check the samples)')
    }
    
  })
  
  output$flag_outlierstable <- renderTable({
    if (input$par_flag == 'flagstat') {
      outliers_flag(file_flagstat(), 'reads (% of total reads)')
    } else { outliers_flag(file_flagextend(), 'reads (% of total reads)')
    }
  })
  
  output$flag_table <- renderDT({
    
    if (input$par_flag == 'flagstat'){
      file <- file_flagstat() # reactive cannot be used directly on datatable
      datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
                # It is important to style the DataTables enhanced tables in a manner which suits your design,
                # so the tables fit in seamlessly with the rest of your site / app >> bootstrap or default
                options = list(scrollX = TRUE,
                               fixedColumns = list(leftColumns = 2, rightColumns = 0)),
                caption = htmltools::tags$caption(
                  style = 'caption-side: bottom;',
                  htmltools::em('reads(%) divided by the total reads; failed: reads that failed on QC',  
                    style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatPercentage(columns = colnames(file[,-c(1,2)]), digits = 2)
    } else {
      file <- file_flagextend()
      datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
                options = list(scrollX = TRUE,
                               fixedColumns = list(leftColumns = 2, rightColumns = 0)),
                caption = htmltools::tags$caption(
                  style = 'caption-side: bottom;',
                  htmltools::em('reads(%) divided by the total reads',
                                style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatPercentage(columns = colnames(file[,-c(1,2)]), digits = 2)
    }
  })
  
#####################################################################################################
   file_cov <- reactive({
    df <- read.csv2(paste0(path, 'depthofcov/depthofcov_merged/', input$par_cov, '_', input$var_cov, '.csv'))
  })
  
  output$txt_cov <- renderText({'table shown in the bottom'})
  
  output$cov_plot <- renderPlotly({
    if (input$par_cov == 'chr') {
      df <- gather_fun_cov(path, input$var_cov)
      graph_function(df, illu_cov(input$var_cov)[[2]], 'Chromosomes', 'Coverage', 1000, 700)
    }
    else {
      df <- file_cov()
      colnames(df) <- c('samples', 'value')
      df['chromosomes'] <- rep(0, length(rownames(df)))
      graph_function(df, paste0(illu_cov(input$var_cov)[[2]], '(', input$par_cov, ' of 24 chromosomes)'), '','Coverage',
                     600, 500)
    }
  })
  
  output$cov_table <- renderDT({
    if (input$par_cov == 'chr') {
      file <- read.csv2(paste0(path, 'depthofcov/', input$var_cov, '.csv'))[,-1]
      rownames(file) <- file[,'chromosome']
      file <- t(file[,-1])
      datatable(file, options = list(scrollX = TRUE), 
                caption = htmltools::tags$caption(
                  style = 'caption-side: up;',
                  htmltools::em(paste0(illu_cov(input$var_cov)[[1]], ' , for all chromosomes'),
                                style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatRound(columns = colnames(file), digits = 2)
    } else {
      df <- file_cov()
      colnames(df) <- c('samples', 'Coverage')
      datatable(df,
                #options = list(autoWidth = TRUE,
                #columnDefs = list(list(width = '200px', targets = c(2)))),
                caption = htmltools::tags$caption(
                  style = 'caption-side: up;',
                  htmltools::em(illu_cov(input$var_cov)[[1]],
                                style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatRound(columns = colnames(df), digits = 2)
    }
  })
  
  outliers_covdf <- eventReactive(input$outliersButton, {
    if (input$par_cov == 'chr') {
      df <- gather_fun_cov(path, input$var_cov)
      outliers_function(df, 'Chromosomes', 'Coverage')
    } else {
      df <- file_cov()
      colnames(df) <- c('samples', 'value')
      df['chromosomes'] <- rep(0, length(rownames(df)))
      outliers_function(df, illu_cov(input$var_cov)[[2]], 'Coverage')
    }
  })
  
  output$cov_outliers <- renderTable({
    outliers_covdf()
  })
  
###################################################################################################
  
  file_globalmethy <- reactive({
    df <- read.csv2(paste0(path, 'globalmethy_merged/', input$par_globalmethy, '_', input$var_globalmethy, '.csv'))
  })
  
  output$globalmethy_plot <- renderPlotly({
    if (input$par_globalmethy == 'chr') {
      df <- gather_fun_globalmethy(path, input$var_globalmethy)
      graph_function(df, illu_globalmethy(input$var_globalmethy), '', '', 1000, 700)
    }
    else {
      df <- file_globalmethy()
      colnames(df) <- c('samples', 'value')
      df['chromosomes'] <- rep(0, length(rownames(df)))
      graph_function(df, paste0(illu_globalmethy(input$var_globalmethy), 
                                '(', input$par_globalmethy, ' of all chromosomes)'), '', '', 600, 500)
    }
  })
  
  output$globalmethy_table <- renderDT({
    if (input$par_globalmethy == 'chr') {
      file <- read.csv2(paste0(path, input$var_globalmethy, '.csv'),  sep = ',')[,-1]
      rownames(file) <- file[,'chromosomes']
      file <- t(file[,-1])
      datatable(file, options = list(scrollX = TRUE),
                caption = htmltools::tags$caption(
                  style = 'caption-side: up;',
                  htmltools::em(paste0(illu_globalmethy(input$var_globalmethy), ' ,for all chromosomes'),
                                style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black')))
    }
    else {
      df <- file_globalmethy()
      colnames(df) <- c('samples', illu_globalmethy(input$var_globalmethy))
      datatable(df, width = 1)
    }
  })
  
  outliers_globalmethydf <- eventReactive(input$outliersButton_globalmethy, {
    if (input$par_globalmethy == 'chr') {
      df <- gather_fun_globalmethy(path, input$var_globalmethy)
      outliers_function(df,  'chromosomes', illu_globalmethy(input$var_globalmethy))
    } else {
      df <- file_globalmethy()
      colnames(df) <- c('samples', 'value')
      df['chromosomes'] <- rep(0, length(rownames(df)))
      outliers_function(df, 'methylation variables', illu_globalmethy(input$var_globalmethy))[,c(1,3)]
    }
  })  
  
  output$globalmethy_outliers <- renderTable({
    outliers_globalmethydf()
  })
  
###################################################################################################
  
  file1_pos <- reactive({
    read.csv2(paste0(path, 'methylationpos_merged/', input$par_pos,
                     '_Y_position_', input$mate_pos, '_CG_mC_ratio.csv'), sep = ';')
  })
  
  file2_pos <- reactive({
    read.csv2(paste0(path, input$par_pos, '_position_', input$mate_pos, '_CG_mC_ratio.csv'))
  })
  
  output$pos_plot <- renderPlot({
    # because graphic device are already on for ggplot, have to close thet device
    #dev.cur() # find out which device is on
    #dev.off(i)  # close it
    title <- paste0(input$par_pos, ' methylation level (at CG site) for each read position (', input$mate_pos, ')' )
    if (input$par_pos == 'mean' | input$par_pos == 'median') {
      file <- file1_pos()[,-1]
      heatmap_fun(file, title)
    }
    else {
      file <- file2_pos()[,-1]
      heatmap_fun(file, title)
    }
  })
  
  output$txt_pos <- renderText({'divide the read positions into three groups to get the mean methylation level'})
  
  output$pos_table <- renderDT({
    if (input$par_pos == 'mean' | input$par_pos == 'median') {
      file <- file1_pos()[1:101,-1]
      file <- groupreadpos(file, input$bin1, input$bin2)
      datatable(file, options = list(scrollX = TRUE)) %>% formatPercentage(columns = colnames(file), digits = 2)
    }
    else {
      file <- file2_pos()[1:101,-1]
      file <- groupreadpos(file, input$bin1, input$bin2)
      datatable(file, options = list(scrollX = TRUE)) %>% formatPercentage(columns = colnames(file), digits = 2)
    }
  })
  
###################################################################################################
  
  title_methycov <- reactive({
    paste0('(', input$par_methycov, ') number of ' , input$var_methycov, ' sites at each ',  input$var_methycov, ' coverage')
  })
  
  y_methycov <- reactive({
    paste0('number of ', input$var_methycov, ' sites')
  })
  
  file1_methycov <- reactive({
    read.csv2(paste0(path, 'methylationcov_merged/', input$par_methycov, '_Y_cov_', input$var_methycov, '.csv'), sep = ';')
  })
  
  file2_methycov <- reactive({
    read.csv2(paste0(path, input$par_methycov, '_cov_', input$var_methycov, '.csv'), sep = ';')
  })
  
  output$methycov_plot <- renderPlotly({
    
    if (input$par_methycov == 'mean' | input$par_methycov == 'median') {
      file <- file1_methycov()
      graph_fun_methycov(file, title_methycov(), paste0(input$var_methycov, ' sites'))
    } else {
      file <- file2_methycov()
      graph_fun_methycov(file, title_methycov(), paste0('(By chromosomes) ', input$var_methycov))
    }
  })
  
  output$methycov_table <- renderDT({
    if (input$par_methycov == 'mean' | input$par_methycov == 'median') {
      file <- file1_methycov()[,-1]
      rownames(file) <- file[,'pos']
      file <- t(file[,-1])
      datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
                options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 1, rightColumns = 0)),
                caption = htmltools::tags$caption(
                  style = 'caption-side: bottom;',
                  htmltools::em(paste0(title_methycov(), ' ( larger than 200 coverage is groupped into coverage 200)'),
                                style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatRound(columns = colnames(file), digits = 2)
    } else {
      file <- file2_methycov()[,-1]
      rownames(file) <- file[,'pos']
      file <- t(file[,-1])
      datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
                options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 1, rightColumns = 0)),
                caption = htmltools::tags$caption(
                  style = 'caption-side: bottom;',
                  htmltools::em(paste0('in chromosome', title_methycov(), ' (larger than 200 coverage is groupped into coverage 200)'),
                                style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatRound(columns = colnames(file), digits = 1)
    }
  })
  
#####################################################################################################
  
  file1_baseq <- reactive({
    read.csv2(paste0(path, 'baseq_merged/', input$par_baseq,
                     '_Y_baseq_', input$mate_baseq, '_CG_mC_ratio.csv'))
  })
  file2_baseq <- reactive({
    read.csv2(paste0(path, input$par_baseq, '_baseq_', input$mate_baseq, '_CG_mC_ratio.csv'))
  })
  title_baseq <- reactive({
    paste0('(', input$par_baseq, ') methylation level of CG sites at each baseQ score (', input$mate_baseq, ')')
  })
  
  output$baseq_plot <- renderPlotly({
    if (input$par_baseq == 'mean' | input$par_baseq == 'median') {
      file <- file1_baseq()
      graph_fun_baseq(file, title_baseq())
    }
    else {
      file <- file2_baseq()
      graph_fun_baseq(file, title_baseq())
    }
  })
  
  output$baseq_plot1 <- renderPlotly({
    if (input$par_baseq == 'mean' | input$par_baseq == 'median') {
      file <- file1_baseq()
      graph_fun_baseq1(file)
    }
    else {
      file <- file2_baseq()
      graph_fun_baseq1(file)
    }
  })
  
  output$baseq_table <- renderDT({
    if (input$par_baseq == 'mean' | input$par_baseq == 'median') {
      file <- file1_baseq()[,-1]
      rownames(file) <- file[,'pos']
      file <- t(file[,-1])
      datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
                options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 1, rightColumns = 0)),
                caption = htmltools::tags$caption(
                  style = 'caption-side: bottom;',
                  htmltools::em(title_baseq(), style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatRound(columns = colnames(file), digits = 2)
    } else {
      file <- file2_baseq()[,-1]
      rownames(file) <- file[,'pos']
      file <- t(file[,-1])
      datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
                options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 1, rightColumns = 0)),
                caption = htmltools::tags$caption(
                  style = 'caption-side: bottom;',
                  htmltools::em(paste0('in chromosome', title_baseq()),
                                style = 'font-family:Comic Sans MS;
                          font-size:120%;color:black'))) %>%
        formatRound(columns = colnames(file), digits = 2)
    }
  })
  
#####################################################################################################

  file_all <- reactive({
    file <- read.csv2(paste0(path, input$sites_freq, '_merged/', input$strand_freq, '_', input$sites_freq, 'CG.csv'))
  })
  
  file_chr <- reactive({
    file <- read.csv2(paste0(path, input$par_freq, '_', input$strand_freq, '_', input$sites_freq, 'CG.csv'))
  })
  
  title_freq <- reactive({
    paste0('(', input$par_freq, ' chromosome)', ' CpG sites ( ',
           input$sites_freq, ')', ' Methylation Level (',  input$strand_freq, ' strand)')
  })
  title_subgroup <- reactive({
    paste0('(', input$par_subgroup, ' chromosome)', ' CpG sites ( ',
           input$sites_subgroup, ')', ' Methylation Level (',  input$strand_subgroup, ' strand)')
  })
  
  output$freq_plot <- renderPlotly({
    
    if (input$par_freq == 'allchr') {
      file <- file_all()
      graph_fun_freq(file, title_freq())
    }
    else {
      file <- file_chr()
      graph_fun_freq(file, title_freq())
    }
  })
  
####################################################################################################
  
  file_all1 <- reactive({
    file <- read.csv2(paste0(path, input$sites_subgroup, '_merged/',
                             input$strand_subgroup, '_', input$sites_subgroup, 'CG.csv'))
  })
  
  file_chr1 <- reactive({
    file <- read.csv2(paste0(path, input$par_subgroup, '_', input$strand_subgroup, '_', input$sites_subgroup, 'CG.csv'))
  })
  
  output$plot_pca <- renderPlotly({
    if (input$par_subgroup == 'allchr') {
      file <- file_all1()
      pca_fun(file, paste0(title_subgroup(), 'PCA'))
    }
    else {
      file <- file_chr1()
      pca_fun(file, paste0(title_subgroup(), 'PCA'))
    }
    
  })
  
  output$naomit <- renderText({ 
    if (input$par_subgroup == 'allchr') {
      file <- file_all1()
      names <- naomit_fun(file)
      paste0(names, '; ')
    }
    else {
      file <- file_chr1()
      names <- naomit_fun(file)
      paste0(names, '; ')
    }
  })
  output$txt_pca <- renderText({'are removed because 75% of CpG sites do not have read count'})
  
  output$plot_dendro <- renderPlotly({
    if (input$par_subgroup == 'allchr') {
      file <- file_all1()
      dendro_fun(file, paste0(title_subgroup(), ' Clustering'))
    }
    else {
      file <- file_chr1()
      dendro_fun(file, paste0(title_subgroup(), ' Clustering'))
    }
  })
  
#######################################################################################################
  
  file_total <- reactive({
    file_rnaseqqc(path, 'total')
  })
  
  file_mapped <- reactive({
    file_rnaseqqc(path, 'mapped')
  })
  
  file_transcripts <- reactive({
    file_rnaseqqc(path, 'transcripts')
  })
  
  file_strand <- reactive({
    file_rnaseqqc(path, 'strand')
  })
  
  output$plot_total <- renderPlotly({
    rnaseqc(file_total(), 'RNASeq Read Count Metrics (Total Reads)', 1000, 2300)[[1]]
  })
  
  output$table_total <- renderDT({
    file <- file_total()
    a <- c('samples','rRNA Rate')
    file <- file[,c(a, colnames(file)[which(!(colnames(file) %in% a))])]
    datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
              options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 2, rightColumns = 0))) %>% 
      formatStyle('rRNA Rate', color = 'red', backgroundColor = 'orange', fontWeight = 'bold')
  })
  
  output$outliers_total <- renderTable({
    rnaseqc(file_total(), 'RNASeq Read Count Metrics (Total Reads)', 1000, 2300)[[2]]
  })
  
  output$rrnarate <- renderPlotly({
    rrnarate(file_total())
  })
#################################################################
  output$plot_mapped <- renderPlotly({
    rnaseqc(file_mapped(), 'RNASeq Read Count Matrics (Mapped Reads)', 1000, 1800)[[1]]
  })
  
  output$table_mapped <- renderDT({
    file <- file_mapped()
    datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
              options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 2, rightColumns = 0)))
  })
  
  output$outliers_mapped <- renderTable({
    rnaseqc(file_mapped(), 'RNASeq Read Count Metrics (Mapped Reads)', 1000, 1800)[[2]]
  })
#################################################################
  output$plot_strand <- renderPlotly({
    rnaseqc(file_strand(),  'RNASeq Read Count Metrics (Strand Specificity)', 1000, 1200)[[1]]
  })
  
  
  output$txt_sense <- renderText({  
    file <- file_strand()
    
    if (mean(as.numeric(file[,'End1 Percentage Sense'])) > 90) {
      if (input$txt_anno == 'firststr') {
        'They are the antisense transcripts and DNA sense strand is the original template.'
      } else if (input$txt_anno == 'secondstr') { 
       'They are the sense transcripts and DNA anti-sense strand is the original template.'
      } else if (input$txt_anno == 'unstr') { 
       'It is strand specific library.' } 
    }
    
    if (mean(as.numeric(file[,'End2 Percentage Sense'])) > 90) {
      if (input$txt_anno == 'firststr') {
       'They are the sense transcripts and DNA anti-sense strand is the original template.'
      } else if (input$txt_anno == 'secondstr') { 
       'They are the antisense transcripts and DNA sense strand is the original template.'
      } else if (input$txt_anno == 'unstr') { 
        'It is strand specific library.' } 
    }
    
  })
  
  output$table_strand <- renderDT({
    file <- file_strand()
    a <- c('samples', 'End1 Percentage Sense', "End2 Percentage Sense")
    file <- file[,c(a, colnames(file)[which(!(colnames(file) %in% a))])]
    datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
              options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 2, rightColumns = 0))) %>%
      formatStyle(c('End1 Percentage Sense', "End2 Percentage Sense"), color = 'red', backgroundColor = 'orange', fontWeight = 'bold')
  })
  
  output$outliers_strand <- renderTable({
    rnaseqc(file_strand(), 'RNASeq Read Count Matrics (Strand Specificity)', 1000, 1200)[[2]]
  })
  
  output$sensepercentage <- renderPlotly({
    strands(file_strand())
  })
  
###########################################################################################
  output$plot_transcripts <- renderPlotly({
    rnaseqc(file_transcripts(), 'RNASeq Read Count Metrics (Transcripts Associated Reads)', 1000, 1200)[[1]]
  })
  
  output$table_transcripts <- renderDT({
    file <- file_transcripts()
    a <- c('samples', "Intronic Rate" , "Intergenic Rate", 'Exonic Rate')
    file <- file[,c(a, colnames(file)[which(!(colnames(file) %in% a))])]
    datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
              options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 2, rightColumns = 0))) %>%
      formatStyle(c("Intronic Rate" , "Intergenic Rate", 'Exonic Rate'), color = 'red', backgroundColor = 'orange', fontWeight = 'bold')
  })
  
  output$outliers_transcripts <- renderTable({
    rnaseqc(file_transcripts(), 'RNASeq Read Count Metrics (Transcripts Associated Reads)', 1000, 1200)[[2]]
  })
  
  output$genesmapping <- renderPlotly({
    genemapping(file_transcripts())
  })
  
###########################################################################################
  
  file_genelength <- reactive({
    file1 <- read.csv2(paste0(path, 'explevel_genelength.csv'),
                       stringsAsFactors = FALSE)
    
  })
  
  file_exonlength <- reactive({
    file1 <- read.csv2(paste0(path, 'explevel_exonlength.csv'),
                       stringsAsFactors = FALSE)
    
  })
  
  output$plot_genelength <- renderPlotly({
    if (input$length == 'gene_length') {
      file1 <- file_genelength()
      colnames(file1) <- gsub("^X", "", colnames(file1))
      colnames(file1) <- c('samples', colnames(file1[,-1]))
      exp_len(file1, 'Gene Length', 'Gene Expression Level in each Gene Length Range Across Samples')
    } else {
      file1 <- file_exonlength()
      colnames(file1) <- gsub("^X", "", colnames(file1))
      colnames(file1) <- c('samples', colnames(file1[,-1]))
      exp_len(file1, 'Exon Length', 'Gene Expression Level in each Exon Length Range Across Samples')
    }
  })
  ##########################################################################################
  
  file_exp <- reactive({
    file <- read.csv2(paste0(path, 'explevel_genetype.csv'))
  })
  
  output$plot_exp <- renderPlotly({
    file <- file_exp()
    colnames(file) <- c('samples', colnames(file[,-1]))
    rnaseqc(file, 'RNASeq Expression Level (TPM) for Different Gene Types', 1000, 1200)[[1]]
  })
  
  output$outliers_exp <- renderTable({
    file <- file_exp()
    colnames(file) <- c('samples', colnames(file[,-1]))
    rnaseqc(file, 'RNASeq Expression Level (TPM) for Different Gene Types', 1000, 1200)[[2]]
  })
  
  ###########################################################################################

  output$plot_diffexp <- renderPlot({
    heatmap_rna(path, input$diffgene_heatmap)
  })
  
  output$pca_diffexp <- renderPlotly({
    pca_diffexp(path, input$diffgene_pca)
  })
  
  output$dendro_diffexp <- renderPlot({
    dendro_diffexp(path, input$diffgene_dendro)
  })
  
 
  
  ###########################################################################################
 
  file_flagrna <- reactive({
    flag_file(path, 'flagstat_rna')
  })
  
  output$flagrna_plot <- renderPlotly({
    file <- file_flagrna()
    colnames(file) <- c('samples', colnames(file[,-1]))
    graph_flag(file, 1000, 2300,
               'FLAG read counts across samples (click on the dots to check the samples)')
  })
  
  output$flagrna_outlierstable <- renderTable({
    file <- file_flagrna()
    colnames(file) <- c('samples', colnames(file[,-1]))
    outliers_flag(file,  'reads (% total reads)')
  })
  
  output$flagrna_table <- renderDT({
    file <- file_flagrna()
    colnames(file) <- c('samples', colnames(file[,-1]))
    datatable(file, extensions = c('FixedColumns'), style = 'bootstrap',
              # It is important to style the DataTables enhanced tables in a manner which suits your design,
              # so the tables fit in seamlessly with the rest of your site / app >> bootstrap or default
              options = list(scrollX = TRUE,
                             fixedColumns = list(leftColumns = 2, rightColumns = 0)),
              caption = htmltools::tags$caption(
                style = 'caption-side: bottom;',
                htmltools::em('reads(%) divided by the total reads; failed: reads that failed on QC', 
                               style = 'font-family:Comic Sans MS;font-size:120%;color:black'))) %>%
      formatPercentage(columns = colnames(file[,-c(1,2)]), digits = 2)
  })
  
  }



