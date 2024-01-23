###############################################################################
# # App Description:
#   This app aims to search a database of bones of various bones with images and 
#   metadata attached to each entry. 
#   The initial data was provided by Rotterdam University and compiled by the
#   members of this project.
# # Members:  
#
# # MISC:
#
# ## To Be Built (TBB):
# - App interface for the Home, search, upload, download and help menu items
###############################################################################

# Necessary Packages
library(shiny)
library(DBI)
library(shinydashboard)
library(DT)
library(markdown)
library(RPostgreSQL)

# Initialize Dependencies 
about_text <- readChar("about_text.Rhtml", file.info("about_text.Rhtml")$size)
about_page_ui <- HTML(about_text)

ui <- dashboardPage(
  # Set the Theme
  skin = "purple",
  
  # Header with title
  dashboardHeader(
    title = "S.E.A.L. (Search Edit Archives Library)"
    ),
  
  # Sidebar with navigation tabs
  dashboardSidebar(
    sidebarMenu(
      menuItem("Search", tabName = "search_db", icon = icon("search")),
      menuItem("Create Tables", tabName = "create_table", icon = icon("plus-square")),
      menuItem("Insert Entries", tabName = "insert_value", icon = icon("edit")),
      menuItem("Update Tables", tabName = "update_table", icon = icon("exchange-alt")),
      menuItem("Delete Tables", tabName = "del_table", icon = icon("trash-alt")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
      )
    ),
  
  # Main body with tabs contents
  dashboardBody(
    tabItems(
      tabItem(tabName = "search_db", h2("Search"), uiOutput("1UI_search")),
      tabItem(tabName = "create_table", h2("Create"), uiOutput("2UI_create")),
      tabItem(tabName = "insert_value", h2("Insert Entry"), uiOutput("3UI_Insert"),
      tabItem(tabName = "update_table", h2("Update Table"), uiOutput("4UI_Update")),
      tabItem(tabName = "del_table", h2("Delete Table"), uiOutput("5UI_Delete")),
      tabItem(tabName = "about", h2("About"), uiOutput("6UI_About"))
      )
      )
    )
  )
  
 server <- function(input, output) {
  # Establish connection to the PostgreSQL database
   con <- dbConnect(PostgreSQL(), dbname = "pro306", port = 5432, user = "postgres", password = "password", host = "localhost")
  
  # Reactive expression for the 'specimen' input
  specimen <- reactive({
    input$specimen
  })
  
  # Reactive expression for the 'bone' input
  bone <- reactive({
    input$bone
  })
  
  # Construct SQL query based on the user's input
  query <- reactive({
    if (is.null(specimen()) & is.null(bone())) {
      # Get all records
      query <- "SELECT * FROM msp"
    } else if (!is.null(specimen()) & is.null(bone())) {
      # Get records for specific 'specimen'
      query <- paste0("SELECT * FROM msp WHERE specimen = '", specimen(), "'")
    } else if (is.null(specimen()) & !is.null(bone())) {
      # Get records for specific 'bone'
      query <- paste0("SELECT * FROM msp WHERE bone = '", bone(), "'")
    } else {
      # Get records for specific 'specimen' and 'bone'
      query <- paste0("SELECT * FROM msp WHERE specimen = '", specimen(), "'", " AND bone = '", bone(), "'")
    }
  })
  
  # Execute the SQL query and store the results
  data <- reactive({
    dbGetQuery(con, query())
  })
  
  # Process and transform query results
  filteredData <- reactive({
    data() %>%
      filter(picture_number < 1800) %>%
      select(specimen, bone, picture_number)
  })
  
  # Update the table output based on the filtered data
  output$table <- renderDataTable({
    filteredData()
  })
}

 # update_welcome <- function() {
 #   # Update the welcome message
 #   output$welcome <- renderText({
 #     "Welcome to the Ichono-Bono Database! This interactive application allows you to search, view, and analyze data on a variety of bones. To get started, explore the various tabs and interact with the data visualizations."
 #   })
 #}
 
# Run the application 
shinyApp(ui = ui, server = server)
  
