library(quantmod)
source("helpers.R")


####################
# - Adjust Prices for Inflation doesn't work
# - What will happen if you click "Plot y axis on the log scale"?
#   - getSymbols will re-run, though it doesn't need to. In fact
#     if you re-run it too much, Google finance will cut you off
#     because you are making too many requests and look like a bot.
# - Solution: Limit what gets re-run using reactive expressions
####################

# shinyServer(function(input, output) {
# 
#   output$plot <- renderPlot({
#     data <- getSymbols(input$symb, src = "google", 
#       from = input$dates[1],
#       to = input$dates[2],
#       auto.assign = FALSE)
#                  
#     chartSeries(data, theme = chartTheme("white"), 
#       type = "line", log.scale = input$log, TA = NULL)
#   })
#   
# })


####################
# now when you click "Plot y axis on the log scale"
# - renderPlot will call dataInput()
# - dataInput will check that the dates and symb widgets have not changed
# - dataInput will return its saved data set of stock prices without re-fetching data from Google
# - renderPlot will re-draw the chart with the correct axis.
####################

# shinyServer(function(input, output) {
# 
#   dataInput <- reactive({
#     getSymbols(input$symb, src = "google",
#                from = input$dates[1],
#                to = input$dates[2],
#                auto.assign = FALSE)
#   })
# 
#   output$plot <- renderPlot({
#     chartSeries(dataInput(), theme = chartTheme("white"),
#                 type = "line", log.scale = input$log, TA = NULL)
#   })
# })


####################
# Fix the Adjust Prices for Inflation check button
####################

shinyServer(function(input, output) {

  dataInput <- reactive({
    getSymbols(input$symb, src = "google",
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })

  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })

  output$plot <- renderPlot({
    chartSeries(finalInput(), theme = chartTheme("white"),
                type = "line", log.scale = input$log, TA = NULL)
  })
})

# - A user clicks “Plot y axis on the log scale.”
# - renderPlot re-runs.
# - renderPlot calls finalInput.
# - finalInput checks with dataInput and input$adjust.
# - If neither has changed, finalInput returns its saved value.
# - If either has changed, finalInput calculates a new value with the current
#   inputs. It will pass the new value to renderPlot and store the new value for
#   future queries.