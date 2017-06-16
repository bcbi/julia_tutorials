library(shiny)
library(maps)
library(mapproj)
library(quantmod)

################################
# Introduction to an R Shiny App
################################
# Powerful and High Level tool for building interactive web apps 
# that are well integrated with R, featureful, and fast. 
# The basic idea driving the tool is user interaction. The visualizations
# and other output change reactively to user inputs.

# The Shiny library comes with 11 example apps that showcase its functionality
runExample("01_hello") # a histogram
runExample("02_text") # tables and data frames
runExample("03_reactivity") # a reactive expression
runExample("04_mpg") # global variables
runExample("05_sliders") # slider bars
runExample("06_tabsets") # tabbed panels
runExample("07_widgets") # help text and submit buttons
runExample("08_html") # Shiny app built from HTML
runExample("09_upload") # file upload wizard
runExample("10_download") # file download wizard
runExample("11_timer") # an automated timer

# Run your own app
# - Create a folder in your working directory with your Shiny code
# - Can run the app two ways:
#   - runApp() or using the R Studio GUI
getwd()
setwd('~/Dropbox (Brown)/biol6535/')
runApp('sample_app')
runApp('sample_app', display.mode = 'showcase')


##############################
# Building up a User Interface
##############################

# HTML Content
# Func    Tag       Description
# p	      <p>	      A paragraph of text
# h1    	<h1>	    A first level header
# h2	    <h2>	    A second level header
# h3    	<h3>	    A third level header
# h4    	<h4>	    A fourth level header
# h5	    <h5>	    A fifth level header
# h6	    <h6>	    A sixth level header
# a	      <a>	      A hyper link
# br	    <br>	    A line break (e.g. a blank line)
# div	    <div>	    A division of text with a uniform style
# span	  <span>	  An in-line division of text with a uniform style
# pre	    <pre>	    Text ‘as is’ in a fixed width font
# code	  <code>	  A formatted block of code
# img	    <img>	    An image
# strong	<strong>	Bold text
# em	    <em>	    Italicized text
# HTML	 	          Directly passes a character string as HTML code
h1("My title")

# Widgets
# A web element that the user interacts with and allows them
# to send messages to the Shiny App.
# Widgets always have a name and a label. The name allows the UI to
# talk to the server code, while the label is a string that the user
# sees on the page.

# function	          widget
# actionButton	      Action Button
# checkboxGroupInput	A group of check boxes
# checkboxInput	      A single check box
# dateInput	          A calendar to aid date selection
# dateRangeInput	    A pair of calendars for selecting a date range
# fileInput	          A file upload control wizard
# helpText	          Help text that can be added to an input form
# numericInput	      A field to enter numbers
# radioButtons	      A set of radio buttons
# selectInput  	      A box with choices to select from
# sliderInput	        A slider bar
# submitButton	      A submit button
# textInput	          A field to enter text


#####################################
# Server Code with R Data and Scripts
#####################################

# Creating Interactivity
# - use an *Output function in the ui.R script to place reactive objects in your Shiny app
# - use a render* function in the server.R script to tell Shiny how to build your objects
# - save your render* expressions in the output list, with one entry for each reactive object in your app.
# - create reactivity by including an input value in a render* expression

# Efficiency
# - shinyServer() and the unnamed function inside it gets run once per user
# - render* functions get run each time a user changes an input in the UI
# - Put code that reads in data, loads libraries, links to helper code, etc. 
#   outside of the shinyServer() function because each user does not need 
#   their own copy of the data to set up the server and run R expressions
# - Put code that is user specific like session information inside of the 
#   unnamed function but outside of render functions
# - Only put code that needs to be re-run each time a user changes a widget 
#   in render* functions

source("census_app/helpers.R")
counties <- readRDS("census_app/data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")

runApp('census_app', display.mode = 'showcase')


######################
# Reactive Expressions
######################

# Stock app
# - plots stock prices for a given stock and date range
# - can correct prices for inflation
# GOOG, AAPL
# Quantmod
# - getSymbols() downloads financial data straight from the web
# - chartSeries displays a time series plot
# helpers.R
# - contains a function that adjusts stock prices for inflation

# - A reactive expression saves its result the first time you run it. 
# - The next time the reactive expression is called, it checks if the saved 
#   value has become out of date (i.e., whether the widgets it depends on have changed). 
# - If the value is out of date, the reactive object will recalculate it (and then
#   save the new result). 
# - If the value is up-to-date, the reactive expression will return the saved 
#   value without doing any computation.

# - A reactive expression takes input values, or values from other reactive expressions, 
#   and returns a new value
# - Reactive expressions save their results, and will only re-calculate if their input has changed
# - Create reactive expressions with reactive({ })
# - Call reactive expressions with the name of the expression followed by parentheses ()
# - Only call a reactive expression from within a reactive or a render* function.

runApp('stock_app', display.mode = 'showcase')


###################
# Sharing your Apps
###################

# Two basic options
# - Share your app as two files: server.R and ur.R
#   - only works if users have R
# - Share your app as a web page
#   - more user friendly, but your app will be public with the free version of Shiny Server
#     and your data will get uploaded to the server (not good for sensitive data)
#   - shinyapps.io


###########
# Resources
###########
# - http://shiny.rstudio.com
# - https://shiny.rstudio.com/gallery/
# - https://shiny.rstudio.com/articles/
  
