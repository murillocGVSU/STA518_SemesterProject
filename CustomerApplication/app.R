library(tidyverse)
library(shiny)
library(ggvis)
library(feather)

customers <- read_feather("customers.feather")
axis_vars <- names(customers %>% dplyr::select(where(is.numeric)))
# Define UI for application explores marketing data
ui <- fluidPage(

    # Application title
    titlePanel("Customer Marketing Explorer"),
    
    fluidRow(
        column(4,
               selectInput('educ', 'Education', c('All',unique(as.character(customers$Education))))),
        column(4,
               selectInput('marstat', 'Marital Status', c('All', unique(as.character(customers$Marital_Status))))),
        column(4,
               selectInput('response', 'Response', c('All', unique(as.character(customers$Response)))))
    ),
        sidebarPanel(
            dateRangeInput('dateRange',
                           label = 'Date Client enrolled with company: ',
                           start = min(customers$Dt_Customer), end = max(customers$Dt_Customer),
                           min = min(customers$Dt_Customer, max = max(customers$Dt_Customer))),
            sliderInput('income',
                        label = 'Client Income (US Dollars): ',
                        min = min(customers$Income), max = max(customers$Income), value = c(min(customers$Income),max(customers$Income)))
        ),
    DT::dataTableOutput('table'),
        column(9,
               ggvisOutput('plot1'),
               wellPanel(
                   selectInput("xvar", "X-axis variable", names(customers %>% dplyr::select(where(is.numeric))), selected = "Income"),
                   selectInput("yvar", "Y-axis variable", names(customers %>% dplyr::select(where(is.numeric))), selected = "Recency")))
)
server <- function(input, output) {
    output$table <- DT::renderDataTable(DT::datatable({
        data <- customers
        if (input$educ != 'All') {
            data <- data[data$Education == input$educ,]
        }
        if (input$marstat != 'All') {
            data <- data[data$Marital_Status == input$marstat,]
        }
        if (input$response != 'All') {
            data <- data[data$Response == input$response,]
        }
    data = subset(data, data$Dt_Customer >= input$dateRange[1] & data$Dt_Customer <= input$dateRange[2])
    data = subset(data, data$Income >= input$income[1] & data$Dt_Customer <= input$income[2])
    data
    }))
}
# Run the application 
shinyApp(ui = ui, server = server)
