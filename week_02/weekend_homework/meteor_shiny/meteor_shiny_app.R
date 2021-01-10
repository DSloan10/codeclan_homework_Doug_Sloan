library(tidyverse)
library(shiny)
library(leaflet)
library(CodeClanData)

meteorite_data <- read_csv("cleaned_meteorite_data.csv")

ui <- fluidPage(
    titlePanel("Meteorites Around the World"),
    
    sidebarLayout(
        sidebarPanel = 
            selectInput("year_select",
                        "Year of Discovery?",
                        choices = unique(meteorite_data$year_of_discovery)),
        
            radioButtons("ff_button",
                        "Fell or Found?",
                        choices = c("Fell", "Found")),
    
        
    ),
    
    mainPanel(
        leafletOutput("map_output")
    )
    

)

server <- function(input, output) {
    
    output$map_output <- renderLeaflet({
        meteorite_data %>% 
            filter(year_of_discovery == input$year_select) %>%
            filter(fell_or_found == input$ff_button) %>%
            leaflet() %>%
            addTiles() %>% 
            addCircleMarkers(
                    lat = ~latitude, lng = ~longitud, popup = ~name
            )
    })
    
}

shinyApp(ui = ui, server = server)
