library(shiny)
library(shinydashboard)
library(DT)
library(shinyjs)

# UI for Landing page
about_page_ui <- fluidPage(
  h3("This is the About Page"),
  actionButton("hide_about_page", "Hide About Page")
)

# UI for About Seal page
about_seal_page_ui <- fluidPage(
  h3("This is the About Seal Page")
)

# UI for the search Page:
search_ui <- fluidRow(
  box(
    title = "Search",
    status = "primary",
    solidHeader = TRUE,
    width = 12,
    textInput("search_input", label = "Enter search words", value = ""),
    actionButton("search_button", "Search")
  ),
  fluidRow(
    box(
      title = "Search Results",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      DTOutput("search_result"),
      textOutput("error")
    )
  )
)

# Define UI
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "S.E.A.L."),
  dashboardSidebar(
    sidebarMenu(
      menuItem("View Tables", tabName = "view_table", icon = icon("search")),
      menuItem("Search", tabName = "search_db", icon = icon("search")),
      menuItem("Create Tables", tabName = "create_table", icon = icon("plus-square")),
      menuItem("Update Tables", tabName = "update_table", icon = icon("exchange-alt")),
      menuItem("Insert Entries", tabName = "insert_value", icon = icon("edit")),
      menuItem("Delete Tables", tabName = "del_table", icon = icon("trash-alt")),
      menuItem("Help", tabName = "help", icon = icon("info-circle")),  # Changed "About" to "Help"
      menuItem("About Seal", tabName = "about_seal", icon = icon("info-circle"))  # Added "About Seal" tab
    )
  ),
  
  dashboardBody(
    useShinyjs(),  # Initialize shinyjs
    
    tabItems(
      tabItem(tabName = "view_table",
              DTOutput("table_view")),
      
      tabItem(tabName = "search_db",
              search_ui),
      
      tabItem(tabName = "create_table",
              h2("Create Table")),
      
      tabItem(tabName = "update_table",
              h2("Update Table")),
      
      tabItem(tabName = "insert_value",
              h2("Insert Entry")),
      
      tabItem(tabName = "del_table",
              h2("Delete Table")),
      
      tabItem(tabName = "help",  # Changed "About" to "Help"
              h2("Help"),
              fluidPage(
                actionButton("show_about_page", "Show About Page"),
                uiOutput("about_page")
              )
      ),
      
      tabItem(tabName = "about_seal",  # Added "About Seal" tab
              h2("About Seal"),
              fluidPage(
                # UI components for the "About Seal" tab go here
              )
      )
    )
  )
)
