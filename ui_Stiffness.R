


sidebar <-  dashboardSidebar(
  fileInput("data", "Choose data File"),
  actionButton("goButton", "Go!"),
  )
  


body <-   dashboardBody(
  # tabItems(
  #   tabItem(
  #     tabName = "SpatioTemporal", h2("SpatioTemporal data"),
  fluidRow(
    plotlyOutput("plot")),
  fluidRow(
    htmlOutput("xlims"),
    br(),
    h4("Verbatim plotly `relayout` data"),
    verbatimTextOutput("relayout"),
    downloadButton("downloadData", "Download Data")),
  
  
)

dashboardPage(
  dashboardHeader(title = "CSV trimmer"),
  sidebar,
  body)
