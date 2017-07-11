#"""
#Author      : Swadhin Goswami
#Gmail       : gsmswadhin@gmail.com
#Description : This is a Simple Shiny Application to call rclr utility 
#"""

library(shiny)
library(miniUI)
library(datasets)
library(rClr)
library(shinyjs)
library(shinyBS)

rClr::clrLoadAssembly('C:/Users/sgoswami/Desktop/test/ASConnector/ASConnector/ASConnector/bin/Release/ASConnector.dll')
ShowQueryEditorObj <<- NULL
ShowQueryBuilderObj <<- NULL
#GlobalReturnObj <- NULL
connectorObj <- clrNew('ASConnector.R2ASConnector')

ASConnector <- function() {

ui<-miniPage(
#titlePanel("ASConnector"),
gadgetTitleBar("ASConnector"),
#sidebarLayout(
miniContentPanel(
  sidebarPanel(
  tags$div(style="display:inline-block",title="ShowQueryEditor",bsButton("ShowQueryEditorButton", label = "ShowQueryEditor", block = TRUE,style="primary")),
  p("Click the button to open ShowQueryEditor."),
  br(),
  tags$div(style="display:inline-block",title="ShowQueryBuilder",bsButton("ShowQueryBuilderButton", label = "ShowQueryBuilder", block = TRUE,style="primary")),
  p("Click the button to open ShowQueryBuilder.")
),

mainPanel(
  useShinyjs(),
  #verbatimTextOutput("nText"),
  verbatimTextOutput("nTextQueryEditor"),
  verbatimTextOutput("nTextQueryBuilder")

)
)
)


server <- function(input, output, session) {


	ntextQueryEditor <- eventReactive(input$ShowQueryEditorButton, {
	shinyjs::disable("ShowQueryEditorButton")
	ShowQueryEditorObj <<- clrCall(connectorObj, 'ShowQueryEditor')
        #GlobalReturnObj <- ShowQueryEditorObj  
	stopApp(ShowQueryEditorObj)
  })
  

  
  output$nTextQueryEditor <- renderText({
    ntextQueryEditor()
  })
  
  ntextQueryBuilder <- eventReactive(input$ShowQueryBuilderButton, {
	shinyjs::disable("ShowQueryBuilderButton")
	ShowQueryBuilderObj <<- clrCall(connectorObj, 'ShowQueryBuilder')
        #GlobalReturnObj <- ShowQueryBuilderObj 
	stopApp(ShowQueryBuilderObj)
  })
  
  output$nTextQueryBuilder <- renderText({
    ntextQueryBuilder()
  })
      
 observeEvent(input$done, {
      #timeText <- paste0("\"", as.character(Sys.time()), "\"")
      #rstudioapi::insertText(timeText)
      stopApp()
    })

}

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer, stopOnCancel = TRUE)


}

df  <<- ASConnector()
