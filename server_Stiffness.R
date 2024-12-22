options(shiny.maxRequestSize=2000*1024^2)

server <- function(input, output) {
  # create the plotly time series
  observeEvent(input$goButton, {
    DatadfAl <- fread(input$Data$datapath, skip=9, header=TRUE)
    DatadfAl <-  data.frame(DatadfAl)
    
    dataname <- input$Data[['name']]
    dataname <-  str_remove_all(dataname, ".csv")
    
    setnames(DatadfAl, 2, "Force")
    
    row.names(DatadfAl)<-1:nrow(DatadfAl)
    
    DatadfAl$V1<-1:nrow(DatadfAl)
    
    output$plot <- renderPlotly({
        x = DatadfAl$`Time`
        y=DatadfAl$`Force`
        
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
    
    new_Datadata <- reactive({
      zoom <- event_data("plotly_relayout", "source")
      if(is.null(zoom) || names(zoom[1]) %in% c("xaxis.autorange", "width")) {
        xlim <- "default of plot"
      } else {
        xmin <- zoom$`xaxis.range[0]`
        xmax <- zoom$`xaxis.range[1]`
      }
      
      DatadfAl%>% dplyr::filter(between(Time, xmin, xmax))
      
    })
    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste(dataname, ".csv")
      },
      content = function(file) {
        write.csv(new_Datadata(), file)
      }
    )
    
  })
}