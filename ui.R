


sidebar <-  dashboardSidebar(
  fileInput("Foot", "Choose Left Foot aligned File"),
  fileInput("Pelvis", "Choose Pelvis aligned File"),
  fileInput("Thorax", "Choose Thorax aligned File"),
  fileInput("Hand", "Choose Hand aligned File"),
  actionButton("goButton", "Go!"),
  selectInput("Graph_Type", "Graph Type:",
              c("Pelvis Gyro" = "Pelvis Gyro",
                "Pelvis Rot" = "Pelvis Rot",
                "Thorax Gyro" = "Thorax Gyro",
                "Thorax Rot" = "Thorax Rot",
                "Foot Acc" = "Foot Acc"

                ))

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
                  downloadButton("downloadDataF", "Download Foot"),
                  downloadButton("downloadDataP", "Download Pelvis"),
                  downloadButton("downloadDataT", "Download Thorax"),
                  downloadButton("downloadDataH", "Download Hand")),
           
  
)

dashboardPage(
  dashboardHeader(title = "CSV trimmer"),
  sidebar,
  body)
