library(shiny)
library(plotly)
library(dplyr)

eagles <- read.csv("EaglePairs2007.csv", header = TRUE)

# Define server logic required to draw plotly
shinyServer(function(input, output) {
    
    eagles$hover <- with(eagles, paste(State, '<br>', "Eagle Pairs:", Eagle_Pairs))
    
    borders <- list(color = toRGB("black"))
    
    map_options <- list(
        scope = 'usa',
        projection = list(type = 'albers usa'),
        showlakes = TRUE,
        lakecolor = toRGB('white')
    )
    
    values <- reactiveValues()
    
    observe ({
        
        if (input$selectM=="P") {
            
            values$eagles_select <- eagles[eagles$Eagle_Pairs > input$sliderPOP[1] & eagles$Eagle_Pairs <= input$sliderPOP[2], ]
        }
        else {
            values$Select_State <- input$selectstate
            values$eagles_select <- eagles[eagles$State == values$Select_State, ]
        }
    })
    
    output$graph <- renderPlotly({
        plot_ly(values$eagles_select, z = ~Eagle_Pairs, text = ~hover, locations = ~Abbrev,
                type = 'choropleth', locationmode = 'USA-states',
                color = ~Eagle_Pairs, colors = 'Greens', marker = list(line = ~borders)) %>%
            layout(geo = map_options) 
        
    })
    output$table <- renderDataTable({
        values$eagles_select[, -4]

    })
    output$sliderP <- renderText({
        sum(values$eagles_select[, 3])
    })
    output$selectP <- renderText({
        paste(substr((sum(values$eagles_select[, 3]) / sum(eagles$Eagle_Pairs))*100, 1, 5),"%")
    })
    output$totalE <- renderText({ 
        sum(eagles$Eagle_Pairs)
    })
})
