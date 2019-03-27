shinyUI(
  fluidPage(shinythemes::themeSelector(),
            navbarPage("Finery X NYCDSA: UI of the Future",
                       tabPanel("Wardrobe Wizard",
                                sidebarLayout(
                                  sidebarPanel(
                                    # Input User ID
                                    selectizeInput(inputId = "user_id",
                                                   label = "User ID",
                                                   choices = user_ids),
                                    # Input algorithm of choice
                                    selectizeInput(inputId = "algo",
                                                   label = "Algorithm",
                                                   choices = algos),
                                    # selectizeInput(id = "filter",
                                    #                label = "Filter",
                                    #                choices = filters)#,
                                    # Input number of recommendations
                                    selectizeInput(inputId = "num_recs",
                                                   label = "Number of Recommendations",
                                                   selected = 7,
                                                   choices = c(1:30)),
                                    width = 2
                                  ),
                                  mainPanel(
                                    # Column with user item purchase history and user brand/category history
                                    column(4, h3("Item Purchase History", align = "center"),
                                           htmlOutput("user_item_history"), br(),
                                           h3("Brands & Categories History", align = "center"), br(),
                                           htmlOutput("user_brand_cat_history")),
                                    # Column with item recommendations (anti), brand/category recommendations (anti), and brand/category recommendations (known; this also recommends previously-purchased categories)
                                    column(8, h3("Item Product Recommendations", align = "center"),
                                           htmlOutput("item_recs"), br(),
                                           h3("Brands & Categories Recommendations", align = "center"), br(),
                                           h4("Excluding previous purchases"), br(),
                                           htmlOutput("brand_recs_anti"), br(),
                                           h4 ("Including previous purchases"),
                                           htmlOutput("brand_recs_known")),
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