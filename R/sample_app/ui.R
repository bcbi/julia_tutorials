library(shiny)


####################
# Sample Hello App
####################

shinyUI(fluidPage(

  # Application title
  titlePanel("Hello Shiny!"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(#position = "right",
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))


####################
# Blank App
####################

# shinyUI(fluidPage(
# ))
# # server
# shinyServer(function(input, output) {
# })


####################
# Sidebar Layout
####################

# shinyUI(fluidPage(
#   titlePanel("title panel"),
# 
#   sidebarLayout(#position = 'right',
#     sidebarPanel("sidebar panel"),
#     mainPanel("main panel")
#   )
# ))


####################
# HTML and Image
####################

# shinyUI(fluidPage(
#   titlePanel(em("title panel")),
# 
#   sidebarLayout(#position = 'right',
#     sidebarPanel("sidebar panel",
#                  h1("header 1", align = "center"),
#                  h2("header 2", align = "center"),
#                  h3("header 3", align = "center")),
#     mainPanel(strong("main panel"),
#               img(src = "bigorb.png", height = 400, width = 400))
#   )
# ))


####################
# Basic Widgets
####################

# shinyUI(fluidPage(
#   titlePanel("Basic widgets"),
# 
#   fluidRow(
# 
#     column(3,
#            h3("Buttons"),
#            actionButton("action", label = "Action"),
#            br(),
#            br(),
#            submitButton("Submit")),
# 
#     column(3,
#            h3("Single checkbox"),
#            checkboxInput("checkbox", label = "Choice A", value = TRUE)),
# 
#     column(3,
#            checkboxGroupInput("checkGroup",
#                               label = h3("Checkbox group"),
#                               choices = list("Choice 1" = 1,
#                                              "Choice 2" = 2, "Choice 3" = 3),
#                               selected = 1)),
# 
#     column(3,
#            dateInput("date",
#                      label = h3("Date input"),
#                      value = "2014-01-01"))
#   ),
# 
#   fluidRow(
# 
#     column(3,
#            dateRangeInput("dates", label = h3("Date range"))),
# 
#     column(3,
#            fileInput("file", label = h3("File input"))),
# 
#     column(3,
#            h3("Help text"),
#            helpText("Note: help text isn't a true widget,",
#                     "but it provides an easy way to add text to",
#                     "accompany other widgets.")),
# 
#     column(3,
#            numericInput("num",
#                         label = h3("Numeric input"),
#                         value = 1))
#   ),
# 
#   fluidRow(
# 
#     column(3,
#            radioButtons("radio", label = h3("Radio buttons"),
#                         choices = list("Choice 1" = 1, "Choice 2" = 2,
#                                        "Choice 3" = 3),selected = 1)),
# 
#     column(3,
#            selectInput("select", label = h3("Select box"),
#                        choices = list("Choice 1" = 1, "Choice 2" = 2,
#                                       "Choice 3" = 3), selected = 1)),
# 
#     column(3,
#            sliderInput("slider1", label = h3("Sliders"),
#                        min = 0, max = 100, value = 50),
#            sliderInput("slider2", "",
#                        min = 0, max = 100, value = c(25, 75))
#     ),
# 
#     column(3,
#            textInput("text", label = h3("Text input"),
#                      value = "Enter text..."))
#   )
# 
# ))
