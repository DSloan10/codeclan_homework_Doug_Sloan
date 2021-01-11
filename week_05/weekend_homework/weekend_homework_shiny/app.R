library(shiny)
library(tidyverse)
library(CodeClanData)

game_data <- CodeClanData::game_sales

ui <- fluidPage(
    
    theme = "cerulean",
    
    titlePanel("Games Data"),
    
    tabsetPanel(
        tabPanel("Sales vs User Scores",
                 fluidRow(
                     column(4,
                 
                
# So it would be good at this stage if we could work out how to get the select inputs to relate to one another. In other words, if "Nintendo" is selected for publisher, then only consoles that run Nintento's games should show up in the latter selectInput. Group by or maybe we can get it right in here??

                selectInput("genre_input",
                            "Genre",
                           choices = unique(game_data$genre)
                )
                    ),
                 
                    column(4,
                
                selectInput("platform_input",
                            "Platform",
                            choices = unique(game_data$platform)
                )
                    ),

 #                   column(8,

 #               sliderInput("year_input", 
#                            "Year of Release Range",
#                            min = min(game_data$year_of_release),
#                            max = max(game_data$year_of_release),
#                            value = as.numeric(c("1988", "2008")),
#                            step = 1
#                )
#                    ),

                    column(12, 
                           
                          actionButton("update", "Find Games")
                    ),
                    
        fluidRow(
            
            column(8,

        plotOutput("sales_user_output", 
                   #click = "plot_click"
                   )
        #,
        #verbatimTextOutput("info")
        
            )
        )
        )
    )
    


    
)

)


server <- function(input, output) {
    
    game_data_plus <- eventReactive(input$update, {

        game_data %>%
            filter(genre == input$genre_input) %>% 
            filter(platform == input$platform_input)
#            filter(year_of_release == input$year_input)
             
            
    })
    
        output$sales_user_output <- renderPlot({
            ggplot(game_data_plus()) +
            aes(x = sales, y = user_score, colour = name) +
            geom_point(position = "jitter") +
                scale_y_continuous(breaks = 1:10) +
            xlab("\nSales (millions)") +
            ylab("User Rating\n") +
            theme(legend.position = "bottom") + 
            geom_text(aes(label = name),
                      check_overlap = TRUE)
           
    
    })
}


shinyApp(ui = ui, server = server)
