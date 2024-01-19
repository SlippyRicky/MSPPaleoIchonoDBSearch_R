###############################################################################
# # App Description:
#   This app aims to search a database of bones of various bones with images and 
#   metadataa attached to each entry. 
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
about_text <- readChar("about_text.html", file.info("about_text.html")$size)
about_page_ui <- HTML(about_text)

ui <- dashboardPage(
  # Header with title
  dashboardHeader(
    title = "Ichono-Bono Database"
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
      ttabItem(tabName = "about",
               h2("About"),
               insertUI("about_page",
                        ui = about_page_ui)
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # Sever Logic
}

# # Update the welcome message when the app starts
# update_welcome()

# Run the application 
shinyApp(ui = ui, server = server)
  
  