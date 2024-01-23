# Server logic
server <- function(input, output, session) {
  # Read data reactively
  data <- reactive({
    read.csv("bone_data.csv")
  })
  
  # Render the table view
  output$table_view <- renderDT({
    data()
  })
  
  # Implement the search logic
  output$search_result <- renderPrint({
    # Your search logic using input$bone_name goes here
  })
  
  # Show/hide About page dynamically
  observeEvent(input$show_about_page, {
    insertUI(
      selector = "#about_page",
      where = "afterEnd",
      ui = about_page_ui
    )
  })
  
  observeEvent(input$hide_about_page, {
    removeUI(selector = "#about_page")
  })
  
  # Render About page UI
  output$about_page <- renderUI({
    about_page_ui
  })
}


