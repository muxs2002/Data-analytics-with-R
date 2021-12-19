# Load libraries
library(shiny)
library(tidyverse)



# Application Layout
shinyUI(
  fluidPage(
    br(),
    # TASK 1: Application title
    titlePanel("Career Services: Census Data App"),
    p("Explore the difference between people who earn less than 50K and more than 50K. You can filter the data by country, then explore various demogrphic information."),
    
    # TASK 2: Add first fluidRow to select input for country
    fluidRow(
      column(12, 
             wellPanel(selectInput("country", "Select a country", choices=c("United-States", "Canada", "Mexico", "Germany", "Philippines"))   
             )
    ),
    
    # TASK 3: Add second fluidRow to control how to plot the continuous variables
    fluidRow(
      column(3, 
             wellPanel(
               p("Select a continuous variable and graph type (histogram or boxplot) to view on the right."),
               radioButtons("continous_variable", "Contious variable", choices=c("age","hours per week")),   # add radio buttons for continuous variables
               radioButtons("graph_type", "Graph Type", choices=c("Histogram", "Boxplot"))    # add radio buttons for chart type
               )
             ),
      column(9, plotOutput(
        "p1",
        
      ))  # add plot output
    ),
    
    # TASK 4: Add third fluidRow to control how to plot the categorical variables
    fluidRow(
      column(3, 
             wellPanel(
               p("Select a categorical variable to view bar chart on the right. Use the check box to view a stacked bar chart to combine the income levels into one graph. "),
               radioButtons("categorical_variable", "Category", choices=c("education","workclass","sex")),    # add radio buttons for categorical variables
               checkboxInput("is_stacked", "Stacked Bar Chart", value = FALSE, width = NULL)     # add check box input for stacked bar chart option
               )
             ),
      column(9, plotOutput(
        "p2",
        width = "100%",
        height = "400px",
        click = NULL,
        dblclick = NULL,
        hover = NULL,
        brush = NULL,
        inline = FALSE
      ))  # add plot output
    )
  )
)
)