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
