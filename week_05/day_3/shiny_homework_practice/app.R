library(shiny)
library(tidyverse)
library(shinythemes)
library(jpeg)

olympics_overall_medals <- read_csv("data/olympics_overall_medals.csv")

sprint_img <- readJPEG("sp-track-b-20160816.jpg")

ui <- fluidPage(
    
    theme = shinytheme("cerulean"),
    
    titlePanel(tags$h3("Five Country Medal Comparison")),
    
    tabsetPanel(
        tabPanel("Medals",
    
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
        ))),
    
        tabPanel("Sources",
                 tags$a("The Olympics Website",
                        href = "https://www.olympic.org/")),
                 tags$a("The Japan Times", href = "https://www.japantimes.co.jp/sports/2016/08/15/olympics/summer-olympics/olympics-track-and-field/bolt-makes-history-third-straight-gold-medal-100-meters-rio-olympics/")
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
            background_image(sprint_img) +
            geom_col() +
            scale_fill_manual(values = case_when(
                input$medal == "Gold" ~ "darkgoldenrod3",
                input$medal == "Silver" ~ "grey75",
                input$medal == "Bronze" ~ "darkorange3"
            )) +
            labs(x = "\nTeam", y = "Medal Total\n") +
            theme(legend.position = ""
            )
            
    
        
    })
}

shinyApp(ui = ui, server = server)