options(shiny.maxRequestSize=2000*1024^2)

server <- function(input, output) {
  # create the plotly time series
  observeEvent(input$goButton, {
    LeftdfAl <- fread(input$Left$datapath)
    #LeftdfAl <- fread(file.choose())
    LeftdfAl <-  data.frame(LeftdfAl)
    
    
    datanameL <- input$Left[['name']]
    datanameL <-  str_remove_all(datanameL, ".csv")
    
    RightdfAl <- fread(input$Right$datapath)
    #RightdfAl <- fread(file.choose())
    RightdfAl <-  data.frame(RightdfAl)
    
    
    datanameR <- input$Right[['name']]
    datanameR <-  str_remove_all(datanameR, ".csv")
    
    row.names(LeftdfAl)<-1:nrow(LeftdfAl)
    row.names(RightdfAl)<-1:nrow(RightdfAl)
    
    LeftdfAl$V1<-1:nrow(LeftdfAl)
    RightdfAl$V1<-1:nrow(RightdfAl)
    
    
    
    output$plot <- renderPlotly({
      if (input$Graph_Type == "Left"){
        x = LeftdfAl$time_s
        y=LeftdfAl$ay_m.s.s
        
      }else if (input$Graph_Type == "Right"){
        x = RightdfAl$time_s
        y=RightdfAl$ay_m.s.s
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
    
    new_Leftdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      LeftdfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
    })
    
    new_Rightdata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      RightdfAl%>% dplyr::filter(between(time_s, xmin, xmax))
      
    })
    
    
    
    
    output$downloadDataL <- downloadHandler(
      filename = function() {
        paste(datanameL, ".csv")
      },
      content = function(file) {
        write.csv(new_Leftdata(), file)
      }
    )
    
    output$downloadDataR <- downloadHandler(
      filename = function() {
        paste(datanameR, ".csv")
      },
      content = function(file) {
        write.csv(new_Rightdata(), file)
      }
    )
  })
}


