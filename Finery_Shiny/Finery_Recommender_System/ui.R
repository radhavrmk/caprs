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
                                    selectizeInput(inputId = "algorithm",
                                                   label = "Algorithm",
                                                   choices = algorithms),
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
                                    column(6, h3("Purchase History", align = "center"), br(),
                                           h4("Items"), br(),
                                           htmlOutput("user_item_history"), br(),
                                           h4("Brands & categories"), br(),
                                           htmlOutput("user_brand_cat_history")),
                                    # Column with item recommendations (anti), brand/category recommendations (anti), and brand/category recommendations (known; this also recommends previously-purchased categories)
                                    column(6, h3("Product Recommendations", align = "center"), br(),
                                           h4("Items (exc. prev. purch.)"), br(),
                                           htmlOutput("item_recs"), br(),
                                           h4("Brands & categories (exc. prev. purch.)"), br(),
                                           htmlOutput("brand_recs_anti"), br(),
                                           h4 ("Brands & categories (inc. prev. purch.)")),
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