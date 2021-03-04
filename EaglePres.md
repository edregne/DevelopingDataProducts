Developing Data Products: Shiny App
========================================================
author: Eric Dregne
date: 3/4/2021
css: style.css
transition: rotate
type: title

Project Details
========================================================
type: exclaim
transition: rotate

This is a shiny app developed to show population density of breeding pairs of bald eagles in the mainland United States of America.

- This project uses a plotly geo-map to demonstrate density.
- A data table is included to show the population values.
- Through this app, the user may gain an understanding of where in the US most bald eagles live and which states they are most likely to see them in the wild.

App Functions
========================================================
type: exclaim
incremental: true
transition: rotate

- The app features selector widgets in the form of dropdowns and a slider.
- The user may select to see the data by population range or view the individual population of a state.
- Totals displayed are the total population selected in the slider/state input, the proportional percentage of the population selection, and the total population of all bald eagle pairs in the US.
- Changes made on the input widgets affect the displayed data in both panels.

App Links
========================================================
type: exclaim
transition: rotate

Shiny App: https://edregne.shinyapps.io/EagleApp/

GitHub ui.R and server.R files: https://github.com/edregne/DevelopingDataProducts

Reference Data: https://www.biologicaldiversity.org/species/birds/bald_eagle/report/

<style>
pre {
  white-space: pre !important;
  overflow-x: scroll !important;
  overflow-y: scroll !important;
  height: 200vh !important;
}
</style>

Server file with Calculations
========================================================
type: exclaim
transition: rotate


```r
library(shiny)
library(plotly)
library(dplyr)

eagles <- read.csv("EaglePairs2007.csv", header = TRUE)

# Set data source for visualizing in plotly and table
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
```
