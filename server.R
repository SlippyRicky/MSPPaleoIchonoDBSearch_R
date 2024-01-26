library(shiny)

# Server logic for the "Update Table" tab
server <- function(input, output, session) {
  # Read data from the "bone_data.csv" file
  data <- reactiveVal(read.csv("bone_data.csv", stringsAsFactors = FALSE))
  
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
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
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
      write.csv(modified_data, "bone_data.csv", row.names = FALSE)
      
      # Update the reactive data
      data(modified_data)
    }
  })
}
