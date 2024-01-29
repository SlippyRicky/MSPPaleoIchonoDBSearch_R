slidenames <- read.csv("SlideNames.csv")
slidenames.vector <- unique(slidenames$Slide.Name)



# Server logic for the "Update Table" tab
server <- function(input, output, session) {
  # Read data from the "data_tags.csv" file
  data <- reactiveVal(read.csv("data_tags.csv", stringsAsFactors = FALSE))
  
  # Reactive value to store updates for About Seal tab
  updates <- reactiveVal(NULL)
  
  # Reactive value to store filtered search results
  filtered_search_results <- reactiveVal(NULL)
  
  # Function to render selected image
  output$selectedImage <- renderImage({
    # Path to directory containing images
    img_dir <- "www/"
    
    # Full file path to the selected (.png added to the end of the names specified in the vector)
    img_path <- file.path(img_dir, paste0(input$image, ".png"))
    
    # Render the selected image
    list(src = img_path, 
         alt = "Selected Image",
         width = "100%")
  }, deleteFile = FALSE) # The file is stored in the UI once loaded (?)
  
  # Update dropdown choices based on slidenames.vector
  observe({
    updateSelectInput(session, "image", choices = slidenames.vector)
  })
  
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
    
    # Store filtered search results in reactive value
    filtered_search_results(filtered_data)
  })
  
  # Render the search table
  output$search_result <- renderDT({
    filtered_data <- filtered_search_results()
    if (!is.null(filtered_data)) {
      datatable(filtered_data, options = list(scrollX = TRUE, searching = FALSE))
    }
  })
  
  # Function to generate CSV file for download
  output$download_search_results <- downloadHandler(
    filename = function() {
      paste("search_results", ".csv", sep = "")
    },
    content = function(file) {
      # Get the displayed search results
      search_results <- filtered_search_results()
      # Write the results to a CSV file
      write.csv(search_results, file, row.names = FALSE)
    }
  )
  
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
      
      # Capture the update
      update <- data.frame(
        Row = cell_row,
        Column = colnames(modified_data)[cell_col],
        Old_Value = modified_data[cell_row, cell_col],
        New_Value = new_value
      )
      
      # Print debugging information
      cat("Cell Edited - Row:", cell_row, "Column:", cell_col, "New Value:", new_value, "\n")
      
      # Update the reactive data
      modified_data[cell_row, cell_col] <- new_value
      data(modified_data)
      
      # Update the reactive value with the captured update
      updates(rbind(updates(), update))
    }
  })
  
  # Expose updates for About Seal tab
  observeEvent(updates(), {
    updates_data <- updates()
    updateTabsetPanel(session, "mainTabs", "about_seal")
    updateTextAreaInput(session, "updates_text", value = paste0(capture.output(updates_data), collapse = "\n"))
  })
}
