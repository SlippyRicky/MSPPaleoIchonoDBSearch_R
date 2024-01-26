# Load necessary libraries
library(shiny)
library(shinydashboard)
library(DT)

# UI for the Search Page
search_ui <- fluidPage(
  titlePanel("Search UI Function"),
  
  # Search input and button
  fluidRow(
    box(
      title = "Search",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      textInput("search_query", "Enter search query", ""),
      actionButton("search_button", "Search")
    )
  ),
  
  # Search results and error message
  fluidRow(
    box(
      title = "Search Results",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      DTOutput("search_results"),
      textOutput("error_message")
    )
  )
)

# Define the server logic
search_server <- function(input, output) {
  # Mock data for demonstration
  data <- data.frame(
    specimen = c("A", "B", "C", "D"),
    bone = c("Femur", "Skull", "Vertebra", "Humerus"),
    picture_number = c(1001, 1502, 1203, 1804)
  )
  
  # Reactive expression for the 'specimen' input
  specimen <- reactive({
    input$search_query
  })
  
  # Construct SQL query based on the user's input
  query <- reactive({
    if (is.null(specimen())) {
      # Get all records if no search query is provided
      query <- "SELECT * FROM data"
    } else {
      # Get records for specific 'specimen'
      query <- paste0("SELECT * FROM data WHERE specimen = '", specimen(), "'")
    }
  })
  
  # Execute the SQL query and store the results
  search_results <- reactive({
    # You can replace this with actual database query using dbGetQuery
    query_result <- subset(data, grepl(specimen(), data$specimen, ignore.case = TRUE))
    return(query_result)
  })
  
  # Render the search results table
  output$search_results <- renderDT({
    datatable(search_results())
  })
  
  # Render an error message if no results are found
  output$error_message <- renderText({
    if (nrow(search_results()) == 0) {
      "No results found."
    } else {
      ""
    }
  })
}

# Define the UI structure
tester_ui <- shinyUI(
  dashboardPage(
    # Set the Theme
    skin = "purple",
    
    # Header with title
    dashboardHeader(
      title = "UI Function Tester"
    ),
    
    # Sidebar with navigation tabs
    dashboardSidebar(
      sidebarMenu(
        menuItem("UI Search", tabName = "ui_search", icon = icon("search"))
      )
    ),
    
    # Main body with tabs contents
    dashboardBody(
      tabItems(
        tabItem(tabName = "ui_search", search_ui)
      )
    )
  )
)



# Define the server logic
search_server <- function(input, output) {
  # Mock data for demonstration
  data <- data.frame(
    specimen = c("A", "B", "C", "D"),
    bone = c("Femur", "Skull", "Vertebra", "Humerus"),
    picture_number = c(1001, 1502, 1203, 1804)
  )
  
  # Reactive expression for the 'specimen' input
  specimen <- reactive({
    input$search_query
  })
  
  # Construct SQL query based on the user's input
  query <- reactive({
    if (is.null(specimen())) {
      # Get all records if no search query is provided
      query <- "SELECT * FROM data"
    } else {
      # Get records for specific 'specimen'
      query <- paste0("SELECT * FROM data WHERE specimen = '", specimen(), "'")
    }
  })
  
  # Execute the SQL query and store the results
  search_results <- reactive({
    # You can replace this with actual database query using dbGetQuery
    query_result <- subset(data, grepl(specimen(), data$specimen, ignore.case = TRUE))
    return(query_result)
  })
  
  # Render the search results table
  output$search_results <- renderDT({
    datatable(search_results())
  })
  
  # Render an error message if no results are found
  output$error_message <- renderText({
    if (nrow(search_results()) == 0) {
      "No results found."
    } else {
      ""
    }
  })
}

# Run the application 
shinyApp(ui = search_ui, server = search_server)

