library(shiny)
library(shinydashboard)
library(DT)

# UI for About page
about_page_ui <- fluidPage(
  h3("This is the About Page"),
  actionButton("hide_about_page", "Hide About Page")
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
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "view_table",
              DTOutput("table_view")),
      tabItem(tabName = "search_db",
              h2("Search Database"),
              textInput("bone_name", label = "Bone Name", value = ""),
              actionButton("search_button", "Search"),
              verbatimTextOutput("search_result")),
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
              fluidPage(
                actionButton("show_about_page", "Show About Page"),
                uiOutput("about_page")
              )
      )
    )
  )
)

