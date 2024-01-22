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
library(shinydashboard)
library(DT)
library(markdown)

# Iniitialize Dependencies 
about_text <- readChar("about_text.Rhtml", file.info("about_text.Rhtml")$size)
about_page_ui <- HTML(about_text)

ui <- dashboardPage(
  # Set the Theme
  skin = "purple",
  
  # Header with title
  dashboardHeader(
    title = "S.E.A.L."
    ),
  
  # Sidebar with navigation tabs
  dashboardSidebar(
    sidebarMenu(
      menuItem("View Tables", tabName = "view_table", icon = icon("search")),
      menuItem("Search", tabName = "search_db", icon = icon("search")),
      menuItem("Create Tables", tabName = "create_table", icon = icon("plus-square")),
      menuItem("Update Tables", tabName = "update_table", icon = icon("exchange-alt")),
      menuItem("Insert Entries", tabName = "insert_value", icon = icon("edit")),
      menuItem("Delete Tables", tabName = "del_table", icon = icon("trash-alt")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
      )
    ),
  
  # Main body with tabs contents
  dashboardBody(
    tabItems(
      tabItem(tabName = "view_table",
              DT::renderDataTable({
                data <- read.csv("bone_data.csv")
                data
              })),
      tabItem(tabName = "search_db",
              h2("Search Database"),
              textInput("bone_name", label="Bone Name", value=""),
              actionButton("search_button", "Search")),
      tabItem(tabName = "create_table",
              h2("Create Table")),
      tabItem(tabName = "update_table",
              h2("Update Table")),
      tabItem(tabName = "insert_value",
              h2("Insert Entry")),
      tabItem(tabName = "del_table",
              h2("Delete Table")),
      tabItem(tabName = "about",
               h2("About"),
               insertUI("about_page",
                        ui = about_page_ui)
               )
      )
    )
  )

server <- function(input, output) {
  # Establish connection to the PostgreSQL database
  con <- dbConnect(
    PostreSQL(),
    dbname = "pro306",
    port = 5432,
    user = "postgres",
    password = "password"
  )
  
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
  
  # Read the about text from the file
  aboutText <- reactive({
    readLines("about_text.Rhtml")
  })
  
  # Use the about text in the UI
  output$aboutText <- renderText({
    aboutText()
  })
  update_welcome <- function() {
    # Update the welcome message
    output$welcome <- renderText({
      "Welcome to the Ichono-Bono Database! This interactive application allows you to search, view, and analyze data on a variety of bones. To get started, explore the various tabs and interact with the data visualizations."
    })
  }
}

# Update the welcome message when the app starts
update_welcome()

# Run the application 
shinyApp(ui = ui, server = server)
  
  