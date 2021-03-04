library(shiny)
library(plotly)

eagles <- read.csv("EaglePairs2007.csv", header = TRUE)

shinyUI(fluidPage(
    titlePanel("Eagle Breeding Pairs in the United States"),
    sidebarLayout(
        sidebarPanel(
            selectInput("selectM", h3("Select Population Range or State"), c("Population Slider" = "P", "State" = "S"), selected = 1),
            sliderInput("sliderPOP", "Range", 0, max(eagles$Eagle_Pairs), value = c(0, max(eagles$Eagle_Pairs))),
            selectInput("selectstate", "State", eagles$State)
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Map",
                         plotlyOutput("graph"),
                         h3("Selected Population:"),
                         textOutput("sliderP"),
                         h3("Proportion of Population:"),
                         textOutput("selectP"),
                         h3("Total Breeding Population:"),
                         textOutput("totalE")),
                tabPanel("Table",
                        dataTableOutput('table'))
                
)))
))
