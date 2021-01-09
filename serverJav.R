options(shiny.maxRequestSize=2000*1024^2)

server <- function(input, output) {
  # create the plotly time series
  observeEvent(input$goButton, {
    LFootdfAl <- fread(input$LFoot$datapath)
    LFootdfAl <-  data.frame(LFootdfAl)
    
    datanameLF <- input$LFoot[['name']]
    datanameLF <-  str_remove_all(datanameLF, ".csv")
    
    RFootdfAl <- fread(input$RFoot$datapath)
    RFootdfAl <-  data.frame(RFootdfAl)
    
    datanameRF <- input$RFoot[['name']]
    datanameRF <-  str_remove_all(datanameRF, ".csv")
    
    PelvisdfAl <- fread(input$Pelvis$datapath)
    PelvisdfAl <-  data.frame(PelvisdfAl)
    
    datanameP <- input$Pelvis[['name']]
    datanameP <-  str_remove_all(datanameP, ".csv")
    
    ThoraxdfAl <- fread(input$Thorax$datapath)
    ThoraxdfAl <-  data.frame(ThoraxdfAl)
    
    datanameT <- input$Thorax[['name']]
    datanameT <-  str_remove_all(datanameT, ".csv")
    
    HanddfAl <- fread(input$Hand$datapath)
    HanddfAl <-  data.frame(HanddfAl)
    
    datanameH <- input$Hand[['name']]
    datanameH <-  str_remove_all(datanameH, ".csv")
    
    row.names(LFootdfAl)<-1:nrow(LFootdfAl)
    row.names(LFootdfAl)<-1:nrow(LFootdfAl)
    row.names(PelvisdfAl)<-1:nrow(PelvisdfAl)
    row.names(ThoraxdfAl)<-1:nrow(ThoraxdfAl)
    row.names(HanddfAl)<-1:nrow(HanddfAl)
    
    LFootdfAl$V1<-1:nrow(LFootdfAl)
    RFootdfAl$V1<-1:nrow(RFootdfAl)
    PelvisdfAl$V1<-1:nrow(PelvisdfAl)
    ThoraxdfAl$V1<-1:nrow(ThoraxdfAl)
    HanddfAl$V1<-1:nrow(HanddfAl)
    
    
    output$plot <- renderPlotly({
      if (input$Graph_Type == "Left Foot Acc"){
        x = LFootdfAl$`time_s`
        y=LFootdfAl$`highg_ay_m.s.s`
        
      }else if (input$Graph_Type == "Right Foot Acc"){
        x = RFootdfAl$`time_s`
        y=RFootdfAl$`highg_ay_m.s.s`
        
      }else if (input$Graph_Type == "Pelvis Gyro"){
        x = PelvisdfAl$`time_s`
        y=PelvisdfAl$`gx_deg.s`
        
        
      }else if (input$Graph_Type == "Pelvis Rot"){
        x = PelvisdfAl$`time_s`
        y=PelvisdfAl$`z_deg`
        
        
      }else if (input$Graph_Type == "Thorax Gyro"){
        x = ThoraxdfAl$`time_s`
        y=ThoraxdfAl$`gx_deg.s`
        
        
      }else if (input$Graph_Type == "Thorax Rot"){
        x = ThoraxdfAl$`time_s`
        y=ThoraxdfAl$`z_deg`
      }
      
      
      p <- plot_ly(x = ~x, y = ~y, mode = 'lines', source = "source")
      
    })
    
    # print the xlims
    output$xlims <- renderText({
      zoom <- event_data("plotly_relayout", "source")
      # if plot just rendered, event_data is NULL
      # if user double clicks for autozoom, then zoom$xaxis.autorange is TRUE
      # if user resizes page, then zoom$width is pixels of plot width
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
        xlim <- paste0("Min: ", xmin, "<br>Max: ", xmax)
      }
      paste0("<h4>X-Axis Limits:</h4> ", xlim)
    })
    
    # print the verbatim event_data for plotly_relayout
    output$relayout <- renderPrint({event_data("plotly_relayout", "source")})
    
    new_LFootdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      LFootdfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
    })
    
    new_RFootdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      RFootdfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
    })
    
    new_Pelvisdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      PelvisdfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
    })
    
    new_Thoraxdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      ThoraxdfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
    })
    
    new_Handdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      HanddfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
    })
    
    
    output$downloadDataLF <- downloadHandler(
      filename = function() {
        paste(datanameLF, ".csv")
      },
      content = function(file) {
        write.csv(new_LFootdata(), file)
      }
    )
    
    output$downloadDataRF <- downloadHandler(
      filename = function() {
        paste(datanameRF, ".csv")
      },
      content = function(file) {
        write.csv(new_RFootdata(), file)
      }
    )
    output$downloadDataP <- downloadHandler(
      filename = function() {
        paste(datanameP, ".csv")
      },
      content = function(file) {
        write.csv(new_Pelvisdata(), file)
      }
    )
    output$downloadDataT <- downloadHandler(
      filename = function() {
        paste(datanameT, ".csv")
      },
      content = function(file) {
        write.csv(new_Thoraxdata(), file)
      }
    )
    output$downloadDataH <- downloadHandler(
      filename = function() {
        paste(datanameH, ".csv")
      },
      content = function(file) {
        write.csv(new_Handdata(), file)
      }
    )
  })
}