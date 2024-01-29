library(shiny)
library(DT)
library(RPostgreSQL)

con <- dbConnect(
  PostgreSQL(),
  dbname = "S.E.A.L.",           #name of imported database
  port = 5432,                   #port of imported server
  user = "postgres",             #username
  password = "password")         #password

# Server logic for the "Update Table" tab
server <- function(input, output, session) {
  # Read data from the "data_tags.csv" file
  initial.query <- "SELECT * FROM data_tags"
  data1 <- dbGetQuery(con, initial.query)
  data2 <- dbGetQuery(con, initial.query)
  
  # Reactive value to store updates for About Seal tab
  updates <- reactiveVal(NULL)
  
  # Render the initial table view without search functionality
  output$table_view1 <- renderDT({
    data1
  }, options = list(scrollX = TRUE, searching = FALSE))
  
  output$table_view2 <- renderDT({
    data2
  }, options = list(scrollX = TRUE, searching = FALSE))
  
  # Implement the refined search logic for Table 1
  observeEvent(input$search_button, {
    search_words <- tolower(strsplit(input$search_input, " ")[[1]])
    
    # Check if search_words is not empty before filtering
    if (length(search_words) > 0) {
      filtered_data1 <- data1[apply(data1, 1, function(row) {
        all(sapply(search_words, function(word) any(grepl(paste0("\\b", word, "\\b"), tolower(row), ignore.case = TRUE))))
      }), ]
    } else {
      filtered_data1 <- data1
    }
    
    output$update_table1 <- renderDT({
      filtered_data1
    }, options = list(scrollX = TRUE, dom = 'Bfrtip', buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  })
  
  # Implement the refined search logic for Table 2
  observeEvent(input$search_button, {
    search_words <- tolower(strsplit(input$search_input, " ")[[1]])
    
    # Check if search_words is not empty before filtering
    if (length(search_words) > 0) {
      filtered_data2 <- data2[apply(data2, 1, function(row) {
        all(sapply(search_words, function(word) any(grepl(paste0("\\b", word, "\\b"), tolower(row), ignore.case = TRUE))))
      }), ]
    } else {
      filtered_data2 <- data2
    }
    
    output$update_table2 <- renderDT({
      filtered_data2
    }, options = list(scrollX = TRUE, dom = 'Bfrtip', buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))
  })
  
  # Render the update table with editable cells for Table 1
  output$update_table1 <- renderDT({
    data_table1 <- data1
    
    datatable(
      data_table1,
      editable = TRUE,
      options = list(
        scrollX = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    )
  })
  
  # Render the update table with editable cells for Table 2
  output$update_table2 <- renderDT({
    data_table2 <- data2
    
    datatable(
      data_table2,
      editable = TRUE,
      options = list(
        scrollX = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    )
  })
  
  # Update the data when a cell is edited for Table 1
  observeEvent(input$update_table1_cell_edit, {
    info <- input$update_table1_cell_edit
    modified_data1 <- data1
    
    if (!is.null(info)) {
      cell_row <- info$row
      cell_col <- info$col
      new_value <- info$value
      
      update1 <- data.frame(
        Row1 = cell_row,
        Column1 = colnames(modified_data1)[cell_col],
        Old_Value1 = modified_data1[cell_row, cell_col],
        New_Value1 = new_value
      )
      
      modified_data1[cell_row, cell_col] <- new_value
      data1(modified_data1)
      
      updates(rbind(updates(), update1))
    }
  })
  
  # Update the data when a cell is edited for Table 2
  observeEvent(input$update_table2_cell_edit, {
    info <- input$update_table2_cell_edit
    modified_data2 <- data2
    
    if (!is.null(info)) {
      cell_row <- info$row
      cell_col <- info$col
      new_value <- info$value
      
      update2 <- data.frame(
        Row2 = cell_row,
        Column2 = colnames(modified_data2)[cell_col],
        Old_Value2 = modified_data2[cell_row, cell_col],
        New_Value2 = new_value
      )
      
      modified_data2[cell_row, cell_col] <- new_value
      data2(modified_data2)
      
      updates(rbind(updates(), update2))
    }
  })
  
  # Expose updates for About Seal tab
  observe({
    updates_data <- updates()
    updateTabsetPanel(session, "mainTabs", "about_seal")
    updateTextAreaInput(session, "updates_text", value = paste0(capture.output(updates_data), collapse = "\n"))
  })
}

shinyApp(ui, server)

