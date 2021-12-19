# Data-analytics-with-R
Data visualization

Quick summary of my problem:
My graphs don't show any informatioon and look empty. My particular problem likely lies in the server.r script. Probably in the logic I used or potential 
something else I’m not entirely sure

![Screenshot Tittle pannel and top half](https://user-images.githubusercontent.com/96080621/146691071-139d3f11-4b25-4fa7-9bfd-e8c8799991d9.png)
![Unchecked work class](https://user-images.githubusercontent.com/96080621/146691078-f816cffe-898f-47de-85dc-6cb8c926cc54.png)



Server code:

# Load libraries
library(shiny)
library(tidyverse)


# Read in data
adult <- read.csv("adult.csv")
# Convert column names to lowercase for convenience 
names(adult) <- tolower(names(adult))

# Define server logic
shinyServer(function(input, output) {
  
  df_country <- reactive({
    adult %>% filter(native_country == input$country)
  })
  
  # TASK 5: Create logic to plot histogram or boxplot
  output$p1 <- renderPlot({
    if (input$graph_type == "Histogram") {
      # Histogram
      ggplot(df_country(),aes(adult[age,hours_per_week]), aes_string( x = input$contious_variable)) +
        geom_histogram( binwidth=100) +  # histogram geom
        labs(title="Selected Categorical variable histogram plot",x="Number of people", y = "Age or Hours per week")+
        theme_classic() +  # labels
        facet_grid(input$categorical_variable~.)    # facet by prediction
    }
    else {
      # Boxplot
      ggplot(df_country(), adult,aes_string(y = input$categorical_variable, x=input$continous_variable)) +
        geom_boxplot(aes(adult)) +  # boxplot geom
        coord_flip() +  # flip coordinates
        labs(title="Plot of selected categorical variables",x="Continous variable", y = "Categorical variable") +  # labels
        facet_grid(input$categorical_variable~.)    # facet by prediction
    }
    
  })
  
  # TASK 6: Create logic to plot faceted bar chart or stacked bar chart
  output$p2 <- renderPlot({
    # Bar chart
    p <- ggplot(df_country(), aes_string(x = input$categorical_variable)) +
      geom_text(aes(label=input$continous_variable)) +  # labels
      theme(legend.position="top")   # modify theme to change text angle and legend position
    
    if (input$is_stacked) {
      p + geom_bar(stat="identity", fill="white")  # add bar geom and use prediction as fill
    }
    else{
      p + 
        geom_bar(stat="identity", fill=input$categorical_variables) + # add bar geom and use input$categorical_variables as fill 
        facet_grid(input$categorical_variable~.)   # facet by prediction
    }
  })
  
})


UI code:

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
