---
output: html_document
runtime: shiny
---
library(tidyverse)
library(shiny)
library(ggvis)
library(feather)

customers <- read_feather("customers.feather")

# Define UI for application explores marketing data
ui <- fluidPage(

    # Application title
    titlePanel("Customer Marketing Explorer"),
    fluidRow(
        column(3,
               wellPanel(
                   h4("Filter"),
                   sliderInput("age", "Client's Recorded Age",
                               0, 100, 30, step = 1),
                   sliderInput("income", "Client's Annual Income",
                               0, 200000, 40000, step = 5000),
                   dateRangeInput('dateRange',
                                  label = 'Date Range Input: yyyy-mm-dd',
                                  start = '2012-07-30', end = '2014-06-29'),
                   sliderInput("kidhome", "Children In-Residence",
                               0, 2, 0, step = 1),
                   sliderInput("teenhome", "Teen In-Residence",
                               0, 2, 0, step = 1),
                   selectInput("marriagestat", "Marital Status",
                               c("Single", "Together", "Married", "Divorced", "Widowed")),
                   selectInput("education", "Client's Level of Education",
                               c("All", "2n Cycle", "Graduation", "Basic", "Master", "PhD"))
               ),
               wellPanel(
                   selectInput("xvar", "X-axis variable", axis_vars, selected = "Income"),
                   selectInput("yvar", "Y-axis variable", axis_vars, selected = "Age")
               ),
               column(9,
                      ggvisOutput("plot1"),
                      wellPanel(
                          span("Number of Clients selected:",
                          textOutput("n_clients"))
               )
               )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
}
# Run the application 
shinyApp(ui = ui, server = server)
