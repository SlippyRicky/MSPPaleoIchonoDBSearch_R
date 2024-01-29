library(shinyjs)
library(shiny)
library(shinydashboard)
library(DT)


slidenames <- read.csv("SlideNames.csv")
slidenames.vector <- unique(slidenames$Slide.Name)


# UI for the Welcome Page
welcome_ui <-fluidPage(
  titlePanel("Image Viewer"),
  p("This database currently contains bone images from six species distributed across three families within the suborder Pinnipedia. The families present are Phocidae (fur seals and sea lions), Odobenidae (walruses) and Phocidae (fur seals) [1], [2]."
)
  
)

# UI for the search Page:
search_ui <- fluidRow(
  box(
    title = "Search",
    status = "primary",
    solidHeader = TRUE,
    width = 12,
    textInput("search_input", label = "Enter search words", value = ""),
    actionButton("search_button", "Search"),
    downloadButton("download_search_results", "Download Search Results")
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


# UI for the update Page:
update_ui <- fluidRow(
  box(
    title = "Update Table",
    status = "primary",
    solidHeader = TRUE,
    width = 12,
    DTOutput("update_table"),
  )
)

# UI for Landing page
about_page_ui <- fluidPage(
  h3("This is the About Page"),
  actionButton("hide_about_page", "Hide About Page")
)

# UI for About Seal page
about_seal_page_ui <- fluidPage(
  titlePanel("Image Viewer"),
  
  sidebarLayout(
    sidebarPanel(
      # Dropdown menu for image selection
      selectInput("image", "Select an Image:",
                  choices = NULL,
                  selected = NULL)
    ),
    
    mainPanel(
      # Code to display selected image
      imageOutput("selectedImage")
    )
  )
)

# Define UI
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "S.E.A.L."),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", icon = icon("home")),
      menuItem("View Tables", tabName = "view_table", icon = icon("search")),
      menuItem("Search & Download", tabName = "search_db", icon = icon("search")),
      menuItem("Create Tables", tabName = "create_table", icon = icon("plus-square")),
      menuItem("Update Tables", tabName = "update_table", icon = icon("exchange-alt")),
      menuItem("Insert Entries", tabName = "insert_value", icon = icon("edit")),
      menuItem("Help", tabName = "help", icon = icon("info-circle")),
      menuItem("About Seal", tabName = "about_seal", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    useShinyjs(),  # Initialize shinyjs
    
    tabItems(
      tabItem(tabName = "welcome",  # New "Welcome" tab
              welcome_ui),
      
      tabItem(tabName = "view_table",
              DTOutput("table_view")),
      
      tabItem(tabName = "search_db",
              search_ui),
      
      tabItem(tabName = "create_table",
              h2("Create Table")),
      
      tabItem(tabName = "update_table",
              h2("Update Table"),
              update_ui),
      
      tabItem(tabName = "insert_value",
              h2("Insert Entry")),
      
      tabItem(tabName = "help",
              h2("Help"),
              fluidPage(
                actionButton("show_about_page", "Show About Page"),
                uiOutput("about_page")
              )
      ),
      
      tabItem(tabName = "about_seal",
              about_seal_page_ui
              )
      )
    )
  )

