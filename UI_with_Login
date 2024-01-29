library(shiny)
library(shinydashboard)
library(DT)
library(shinyjs)
library(sodium)



# Main login screen
loginpage <- div(id = "loginpage", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
                 wellPanel(
                   tags$h2("LOG IN", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
                   img(src = "https://github.com/hxr303/S.E.A.L.-Database/blob/main/FlogoBN.jpg?raw=true", width = "200px", height = "160px", style = "display: block; margin: 0 auto;"),
                   textInput("userName", placeholder="Username", label = tagList(icon("user"), "Username")),
                   passwordInput("passwd", placeholder="Password", label = tagList(icon("unlock-alt"), "Password")),
                   br(),
                   div(
                     style = "text-align: center;",
                     actionButton("login", "SIGN IN", style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
                     shinyjs::hidden(
                       div(id = "nomatch",
                           tags$p("Incorrect username or password!",
                                  style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;", 
                                  class = "text-center"))),
                     br(),
                     br(),
                     tags$code("Username: Admin  Password: pass"),
                     br(),
                     tags$code("Username: Viewer  Password: sightseeing"),
                     br(),
                     tags$code("Username: Guest (Create account)  Password: 123")
                     
                   ))
)

credentials = data.frame(
  username_id = c("Admin", "Viewer", "Guest"),
  passod   = sapply(c("pass", "sightseeing", "123"),password_store),
  permission  = c("advanced", "basic", "none"), 
  stringsAsFactors = F
)

header <- dashboardHeader( title = "S.E.A.L Database",
                           tags$li(
                             class = "dropdown",
                             style = "padding: 8px;",
                             shinyauthr::logoutUI("logout")
                           ),
                           tags$li(
                             class = "dropdown",
                             tags$a(
                               icon("github"),
                               href = "https://github.com/SlippyRicky/PaleoIchonoDBSearch_R.git",
                               title = "Find the code on github"
                             )))


sidebar <- dashboardSidebar(uiOutput("sidebarpanel")) 
body <- dashboardBody(shinyjs::useShinyjs(), uiOutput("body"))
ui<-dashboardPage(header, sidebar, body, skin = "blue")   


server <- function(input, output, session) {
  
  
  login = FALSE
  USER <- reactiveValues(login = login)
  
  observe({ 
    if (USER$login == FALSE) {
      if (!is.null(input$login)) {
        if (input$login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          if(length(which(credentials$username_id==Username))==1) { 
            pasmatch  <- credentials["passod"][which(credentials$username_id==Username),]
            pasverify <- password_verify(pasmatch, Password)
            if(pasverify) {
              USER$login <- TRUE
            } else {
              shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
              shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
            }
          } else {
            shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
            shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
          }
        } 
      }
    }})    
  
  output$logoutbtn <- renderUI({
    req(USER$login)
    tags$li(a(icon("fa fa-sign-out"), "Logout", 
              href="javascript:window.location.reload(true)"),
            class = "dropdown", 
            style = "background-color: #eee !important; border: 0;
                    font-weight: bold; margin:5px; padding: 10px;")
  })
  
  
  output$sidebarpanel <- renderUI({
    if (USER$login == TRUE) {
      user_permission <- credentials[credentials$username_id == isolate(input$userName), "permission"]
      
      menuItems <- list()
      
      if (user_permission %in% c("none")) {
        menuItems <- c(menuItems, list(menuItem("Create account", tabName = "create_account", icon = icon("user"))))
      }
      if (user_permission %in% c("basic")) {
        menuItems <- c(
          menuItems,
          list(menuItem("Search", tabName = "search_db", icon = icon("search"))),
          list(menuItem("About", tabName = "about", icon = icon("info-circle")))
        )
      }
      if (user_permission %in% c("advanced")) {
        menuItems <- c(
          menuItems,
          list(menuItem("Search", tabName = "search_db", icon = icon("search"))),
          list(menuItem("Create Tables", tabName = "create_table", icon = icon("plus-square"))),
          list(menuItem("Insert Entries", tabName = "insert_value", icon = icon("edit"))),
          list(menuItem("Update Tables", tabName = "update_table", icon = icon("exchange-alt"))),
          list(menuItem("Delete Tables", tabName = "del_table", icon = icon("trash-alt"))),
          list(menuItem("About", tabName = "about", icon = icon("info-circle"))),
          list(menuItem("Create account", tabName = "create_account", icon = icon("user")))
        )
      }
      
      sidebarMenu(menuItems)
    }
  })
  
  
  output$body <- renderUI({
    if (USER$login == TRUE ) {
      tabItems(
        tabItem(tabName = "search_db", h2("Search"), uiOutput("1UI_search")),
        tabItem(tabName = "create_table", h2("Create"), uiOutput("2UI_create")),
        tabItem(tabName = "insert_value", h2("Insert Entry"), uiOutput("3UI_Insert")),
        tabItem(tabName = "update_table", h2("Update Table"), uiOutput("4UI_Update")),
        tabItem(tabName = "del_table", h2("Delete Table"), uiOutput("5UI_Delete")),
        tabItem(tabName = "about", h2("About"), uiOutput("6UI_About")),
        tabItem(tabName = "create_account",
                h2("Create Account"),
                textInput("new_username", "Username"),
                passwordInput("new_password", "Password", placeholder = "Beware of the password you use"),
                passwordInput("confirm_password", "Confirm Password"),
                textInput("additional_comments", "Additional Comments", placeholder = "Please write name and student ID if applicable"),
                actionButton("create_account_btn", "Create Account")),
        tabItem(tabName = "results_tab", h2("Results"), DTOutput("results")),
        tabItem(tabName = "results2_tab", h2("Results 2"), DTOutput("results2"))
      )
    }
    else {
      loginpage
    }
  })
  
  output$results <- DT::renderDataTable({
    datatable(iris, options = list(autoWidth = TRUE,
                                   searching = FALSE))
  })
  
  output$results2 <- DT::renderDataTable({
    datatable(mtcars, options = list(autoWidth = TRUE,
                                     searching = FALSE))
  })
}


runApp(list(ui = ui, server = server), launch.browser = TRUE)
