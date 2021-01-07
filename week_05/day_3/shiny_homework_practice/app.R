library(shiny)
library(tidyverse)
library(shinythemes)

olympics_overall_medals <- read_csv("data/olympics_overall_medals.csv")

ui <- fluidPage(
    
    theme = shinytheme("cerulean"),
    
    titlePanel(tags$h3("Five Country Medal Comparison")),
    
    sidebarLayout(
        sidebarPanel(
            radioButtons("season",
                         "Summer or Winter Olympics?",
                         choices = c("Summer", "Winter")
            ),
            radioButtons("medal",
                         "Which Medal?",
                         choices = c("Gold", "Silver", "Bronze")
            )
        ),
        
        mainPanel(
            plotOutput("five_country")
        )
        
        
    )
)


server <- function(input, output) {
    
    
    output$five_country <- renderPlot({
        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal == input$medal) %>%
            filter(season == input$season) %>%
            ggplot() +
            aes(x = team, y = count, fill = medal) +
            geom_col() +
            scale_fill_manual(values = case_when(
                input$medal == "Gold" ~ "#fcba03",
                input$medal == "Silver" ~ "#C0C0C0",
                input$medal == "Bronze" ~ "#cd7f32"
            )) +
            labs(x = "\nTeam", y = "Medal Total\n") +
            theme(legend.position = "")
            
    
        
    })
}

shinyApp(ui = ui, server = server)