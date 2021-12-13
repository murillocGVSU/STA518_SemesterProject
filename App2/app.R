#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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
            radioButtons("x", "Select X-axis:",
                         list("Age"='a', "Income"='b', "Kidhome"='c', "MntWines"='d')),
            radioButtons("y", "Select Y-axis:",
                         list("Age"='e', "Income"='f', "Kidhome"='g', "MntWines"='h'))     ),
            

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
        if(input$x=='a'){       i<-1     } 
        if(input$x=='b'){       i<-2     }
        if(input$x=='c'){       i<-3     } 
        if(input$x=='d'){       i<-4     } 
        if(input$y=='e'){       j<-1     } 
        if(input$y=='f'){       j<-2     } 
        if(input$y=='g'){       j<-3     }  
        if(input$y=='h'){       j<-4     }
        s    <- Teenhome [, i]     k    <- Teenhome [, j]     plot(s,k)   }) }

        # draw the histogram with the specified number of bins
      #  hist(x, breaks = bins, col = 'darkgray', border = 'white')
#    })
#}

# Run the application 
shinyApp(ui = ui, server = server)

  
  





