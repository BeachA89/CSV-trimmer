options(shiny.maxRequestSize=2000*1024^2)

server <- function(input, output) {
  # create the plotly time series
  observeEvent(input$goButton, {
    BoatdfAl <- fread(input$Boat$datapath)
    BoatdfAl <-  data.frame(BoatdfAl)
    
    datanameB <- input$Boat[['name']]
    datanameB <-  str_remove_all(datanameB, ".csv")
    
    PelvisdfAl <- fread(input$Pelvis$datapath)
    PelvisdfAl <-  data.frame(PelvisdfAl)
    
    datanameP <- input$Pelvis[['name']]
    datanameP <-  str_remove_all(datanameP, ".csv")
    
    ThoraxdfAl <- fread(input$Thorax$datapath)
    ThoraxdfAl <-  data.frame(ThoraxdfAl)
    
    datanameT <- input$Thorax[['name']]
    datanameT <-  str_remove_all(datanameT, ".csv")
    
    
    row.names(BoatdfAl)<-1:nrow(BoatdfAl)
    row.names(PelvisdfAl)<-1:nrow(PelvisdfAl)
    row.names(ThoraxdfAl)<-1:nrow(ThoraxdfAl)
    
    BoatdfAl$V1<-1:nrow(BoatdfAl)
    PelvisdfAl$V1<-1:nrow(PelvisdfAl)
    ThoraxdfAl$V1<-1:nrow(ThoraxdfAl)
    
    
    output$plot <- renderPlotly({
      if (input$Graph_Type == "Boat Acc"){
        x = BoatdfAl$`time_s`
        y=BoatdfAl$`ay_m.s.s`
        
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
    
    new_Boatdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      BoatdfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
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
    
    
    output$downloadDataB <- downloadHandler(
      filename = function() {
        paste(datanameB, ".csv")
      },
      content = function(file) {
        write.csv(new_Boatdata(), file)
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
  })
}