


# sidebar <-  dashboardSidebar(
#   fileInput("Foot", "Choose Foot aligned File"),
#   fileInput("Pelvis", "Choose Pelvis aligned File"),
#   fileInput("Thorax", "Choose Thorax aligned File"),
#   fileInput("Hand", "Choose Hand aligned File"),
#   actionButton("goButton", "Go!"),
#   selectInput("Graph_Type", "Graph Type:",
#               c("Pelvis Gyro" = "Pelvis Gyro",
#                 "Pelvis Rot" = "Pelvis Rot",
#                 "Thorax Gyro" = "Thorax Gyro",
#                 "Thorax Rot" = "Thorax Rot",
#                 "Foot Acc" = "Foot Acc"
#                 ))  
# 
# )


sidebar <-  dashboardSidebar(
  fileInput("Left", "Choose Left aligned File"),
  fileInput("Right", "Choose Right aligned File"),
  actionButton("goButton", "Go!"),
  selectInput("Graph_Type", "Graph Type:",
              c("Left" = "Left",
                "Right" = "Right"
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
                  downloadButton("downloadDataL", "Download Left"),
                  downloadButton("downloadDataR", "Download Right")),
           
  
)

dashboardPage(
  dashboardHeader(title = "CSV trimmer"),
  sidebar,
  body)
