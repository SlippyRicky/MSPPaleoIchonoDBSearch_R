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
# about_text <- readChar("about_text.Rhtml", file.info("about_text.Rhtml")$size)
# about_page_ui <- HTML(about_text)

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
      menuItem("Search", tabName = "search_db", icon = icon("search")),
      menuItem("Dowloads", tabName = "downloads", icon = icon("download")),
      menuItem("Insert Entries", tabName = "insert_value", icon = icon("edit")),
      menuItem("Edit Tables", tabName = "edit_table", icon = icon("exchange-alt")),
      menuItem("Delete Tables", tabName = "del_table", icon = icon("trash-alt")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
      )
    ),
  
  # Main body with tabs contents
  dashboardBody(
    tabItems(
      # tabItem(tabName = "search_db", h2("Search"), uiOutput("1UI_search")),
      tabItem(tabName = "search_db",
              h2("Search"),
              fluidRow(
                box(
                  status = "primary",
                  width = 12,
                  textInput("search_input", label = "Enter search words", value = ""),
                  actionButton("search_button", "Search", style = "color: #fff; background-color: #337ab7; border-color: #2e6da4;"),
                  style = "border: 2px solid #337ab7; border-radius: 5px;"
                )
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
      ),
      
      # tabItem(tabName = "downloads", h2("Dowloads"), uiOutput("2UI_download")),
      tabItem(tabName = "downloads",
              h2("Downloads"),
              fluidRow(
                box(
                  title = "Download Table",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  textInput("table_link_input", label = "Enter table link/command", value = ""),
                  actionButton("download_button", "Download Table")
                )
              ),
              fluidRow(
                box(
                  title = "Table Display",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  DTOutput("downloaded_table"),
                  downloadButton("download_local_button", "Download Locally")
                )
              )
      ),
      
      # tabItem(tabName = "insert_value", h2("Insert Entry"), uiOutput("3UI_Insert"),
      tabItem(tabName = "insert_value",
              h2("Insert Entries"),
              fluidRow(
                box(
                  title = "Data Selection",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  textInput("entry_name", label = "Enter Name", value = ""),
                  textInput("entry_description", label = "Enter Description", value = ""),
                  actionButton("submit_button", "Submit Entry")
                )
              ),
              fluidRow(
                box(
                  title = "View Inserted Entries",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  DTOutput("inserted_entries"),
                  textOutput("inserted_entries_status")
                )
              )
      ),
      # tabItem(tabName = "update_table", h2("Update Table"), uiOutput("4UI_Update")),
      tabItem(tabName = "update_table",
              h2("Update Tables"),
              fluidRow(
                box(
                  title = "Select Table to Update",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  selectInput("table_to_update", label = "Select Table", choices = c("Table1", "Table2", "Table3"), selected = NULL)
                )
              ),
              fluidRow(
                box(
                  title = "Update Form",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  textInput("update_column", label = "Column to Update", value = ""),
                  textInput("update_value", label = "New Value", value = ""),
                  actionButton("apply_update_button", "Apply Update"),
                  DTOutput("update_table")
                )
              ),
              fluidRow(
                box(
                  title = "Update Status",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  textOutput("update_status")
                )
              )
      ),
      
      # tabItem(tabName = "del_line", h2("Delete Line"), uiOutput("5UI_Delete")),
      tabItem(tabName = "del_line",
              h2("Delete Line"),
              fluidRow(
                box(
                  title = "Select Table to Delete",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  selectInput("line_to_delete", label = "Select Table", choices = c("Table1", "Table2", "Table3"), selected = NULL),
                  actionButton("delete_line_button", "Delete Line")
                )
              ),
              fluidRow(
                box(
                  title = "Deletion Status",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  textOutput("deletion_status")
                )
              )
      ),
      # tabItem(tabName = "about", h2("About"), uiOutput("6UI_About"))
      tabItem(tabName = "about",
              fluidRow(
                column(width = 12,
                       h2("Welcome to S.E.A.L."),
                       p("S.E.A.L. (Search Edit Archives Library) is a powerful tool for managing and exploring your data."),
                       p("Explore various features and functionalities to make the most out of your data."),
                       p("Feel free to navigate through different tabs to perform actions like searching, creating, inserting, updating, and deleting tables."),
                       p("If you have any questions or need assistance, refer to the help section or contact support.")
                )
              ),
              fluidRow(
                box(
                  title = "Quick Links",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  actionLink("link_search", "Search Tables"),
                  actionLink("link_create", "Create Tables"),
                  actionLink("link_insert", "Insert Entries"),
                  actionLink("link_update", "Update Tables"),
                  actionLink("link_delete", "Delete Tables")
                )
              )
      )
    )
  )
)



server <- function(input, output, session) {

  # connect_to_database <- function(dbname, user, password, host, port) {
  #   con_string <- sprintf("dbname=%s user=%s password=%s host=%s port=%s", dbname, user, password, host, port)
  #   con <- dbConnect(PostgreSQL(), con_string)
  #   return(con)
  # }
  
  # Establish connection to the PostgreSQL database   replace dbname with 'your_actual_dbname'
  con <- dbConnect(PostgreSQL(), dbname = "PaleoDATA", port = 5432, user = "postgres", password = "password", host = "localhost")
  # con <- connect_to_database(dbname = "PaleoDATA",
  #                            port = "5432",
  #                            user = "postgres",
  #                            password = "password",
  #                            host = "localhost"
  #                            )
  
  # Disconnect when the session ends
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
  tables <- dbListTables(con)
  print(tables)
  
  
  
  # Shiny interface Server logic
  
  # Read data from the "bone_data.csv" file
  data <- reactiveVal(read.csv("data_tags.csv", stringsAsFactors = FALSE))
  
  # Render the initial table view without search functionality
  output$table_view <- renderDT({
    data()
  }, options = list(scrollX = TRUE, searching = FALSE))  # Make the DataTable scrollable and remove search functionality
  
  # Implement the refined search logic
  observeEvent(input$search_button, {
    search_words <- tolower(strsplit(input$search_input, " ")[[1]])
    
    # Check if search_words is not empty before filtering
    if (length(search_words) > 0) {
      # Filter data based on the exact presence of search_words in relevant columns
      filtered_data <- data()[apply(data(), 1, function(row) {
        all(sapply(search_words, function(word) any(grepl(paste0("\\b", word, "\\b"), tolower(row), ignore.case = TRUE))))
      }), ]
    } else {
      # If search_words is empty, show all data
      filtered_data <- data()
    }
    
    output$search_result <- renderDT({
      filtered_data
    }, options = list(scrollX = TRUE, searching = FALSE))  # Make the DataTable scrollable and remove search functionality
  })
  
  # Render the update table with editable cells
  output$update_table <- renderDT({
    data_table <- data()
    
    # Use DT::datatable() with editable = TRUE for inline editing
    datatable(
      data_table,
      editable = TRUE,
      options = list(
        scrollX = TRUE,
        dom = 'Bfrtip',  # Add buttons to the table
        # buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    )
  })
  
  # Update the data when a cell is edited
  observeEvent(input$update_table_cell_edit, {
    info <- input$update_table_cell_edit
    modified_data <- data()
    
    if (!is.null(info)) {
      cell_row <- info$row
      cell_col <- info$col
      new_value <- info$value
      
      modified_data[cell_row, cell_col] <- new_value
      
      # Print debugging information
      cat("Cell Edited - Row:", cell_row, "Column:", cell_col, "New Value:", new_value, "\n")
      
      # Write the updated data back to the source file (e.g., CSV)
      write.csv(modified_data, "data_tags.csv", row.names = FALSE)
      
      # Update the reactive data
      data(modified_data)
    }
  })
}
 
# Run the application 
shinyApp(ui = ui, server = server)
  
