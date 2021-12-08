---
output: html_document
runtime: shiny
---
library(shiny)
library(ggplot2)
library(data.table)
library(DT)
library(shinyWidgets)
library(tidyverse)
customers <- read_tsv("Data/marketing_campaign.csv"  )

#Removing outliers to separate df. Very high income, NAs, irrelevant statuses and unlikely ages: total 35 observations removed
outliers <- customers %>% 
    filter(Income > 200000 | is.na(Income) | Marital_Status %in% c('Absurd', 'Alone', 'YOLO') | Year_Birth < 1905)

#Removing Z_CostContact & Z_Revenue for redundancy / no value & anti-joining outliers df
customers <- customers %>% 
    anti_join(outliers) %>% 
    subset(select = -c(Z_CostContact, Z_Revenue))
#Creating age variable and moving to after birth year
customers <- customers %>% 
    mutate(Age = as.numeric(format(Sys.Date(), '%Y')) - Year_Birth) %>% 
    relocate(Age, .after = Year_Birth)



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Customer Marketing Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
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
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- customers[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
