library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")


####################
# Provide R Server Code to Create Reactive Output
####################

# shinyServer(
#   function(input, output) {
#     
#     output$text1 <- renderText({
#       paste("You have selected", input$var)
#     })
#     
#     output$text2 <- renderText({
#       paste("You have chosen a range that goes from",
#             input$range[1], "to", input$range[2])
#     })
#     
#   }
# )


####################
# Add Map
####################

# shinyServer(
#   function(input, output) {
# 
#     output$text1 <- renderText({
#       paste("You have selected", input$var)
#     })
# 
#     output$text2 <- renderText({
#       paste("You have chosen a range that goes from",
#             input$range[1], "to", input$range[2])
#     })
# 
#     output$map <- renderPlot({
#       percent_map()
#     })
# 
#   }
# )


####################
# Fix Map by passing inputs as arguments to percent_map()
####################

shinyServer(
  function(input, output) {
    output$map <- renderPlot({
      data <- switch(input$var,
                     "Percent White" = counties$white,
                     "Percent Black" = counties$black,
                     "Percent Hispanic" = counties$hispanic,
                     "Percent Asian" = counties$asian)

      color <- switch(input$var,
                      "Percent White" = "darkgreen",
                      "Percent Black" = "black",
                      "Percent Hispanic" = "darkorange",
                      "Percent Asian" = "darkviolet")

      legend <- switch(input$var,
                       "Percent White" = "% White",
                       "Percent Black" = "% Black",
                       "Percent Hispanic" = "% Hispanic",
                       "Percent Asian" = "% Asian")

      percent_map(var = data,
                  color = color,
                  legend.title = legend,
                  max = input$range[2],
                  min = input$range[1])
    })
  }
)