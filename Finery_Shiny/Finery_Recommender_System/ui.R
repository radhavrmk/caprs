shinyUI(
  fluidPage(shinythemes::themeSelector(),
            navbarPage("Finery X NYCDSA: UI of the Future",
                       tabPanel("Wardrobe Wizard",
                                sidebarLayout(
                                  sidebarPanel(
                                    # Input User ID
                                    selectInput(inputId = "user_id",
                                                   label = "User ID",
                                                   choices = user_ids),
                                    # Input algorithm of choice
                                    selectInput(inputId = "algo",
                                                   label = "Algorithm",
                                                   choices = algos),
                                    # Input brand filter
                                    selectInput(inputId = "brand_filter",
                                                   label = "Brands",
                                                   choices = brands,
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    # Input category filter
                                    selectInput(inputId = "category_filter",
                                                   label = "Categories",
                                                   choices = categories, 
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    # Input number of recommendations
                                    selectInput(inputId = "num_recs",
                                                   label = "Number of Recommendations",
                                                   selected = 7,
                                                   choices = c(1:30)),
                                    width = 2
                                  ),
                                  mainPanel(
                                    # Column with user item purchase history and user brand/category history
                                    fluidRow(column(4, h3("Item Purchase History", align = "center"), br(),
                                                    htmlOutput("user_item_history")),
                                             column(8, h3("Item Product Recommendations", align = "center"), br(),
                                                    htmlOutput("item_recs"), br())),
                                    fluidRow(column(4, h3("Brands & Categories History", align = "center"), br(),
                                                    htmlOutput("user_brand_cat_history")),
                                             column(8,
                                                    h3("Brands & Categories Recommendations", align = "center"), br(),
                                                    fluidRow(column(6, h4("Excluding previous purchases"), br(),
                                                                    htmlOutput("brand_recs_anti")),
                                                             column(6, h4 ("Including previous purchases"), br(),
                                                                    htmlOutput("brand_recs_known"))))
                                             ),
                                    width = 10
                                  )
                                )
                                ),
                       tabPanel("Algorithms"),
                       tabPanel("About Us",
                                htmlOutput("contact"))
                       )
            )
)