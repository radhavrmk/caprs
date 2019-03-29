shinyUI(
  fluidPage(theme = shinytheme("flatly"),
    #shinythemes::themeSelector(),
            navbarPage("Finery X NYCDSA: UI of the Future",
                       tabPanel("What Should I Wear Today?",
                                sidebarLayout(
                                  sidebarPanel(
                                    # Input User ID
                                    selectizeInput(inputId = "user_id2",
                                                   label = "User ID",
                                                   choices = user_ids),
                                    # Input algorithm of choice
                                    selectizeInput(inputId = "algo2",
                                                   label = "Algorithm",
                                                   choices = algos),
                                    # Input brand filter
                                    selectizeInput(inputId = "brand_filter2",
                                                   label = "Brands",
                                                   choices = brands,
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    # Input category filter
                                    selectizeInput(inputId = "category_filter2",
                                                   label = "Categories",
                                                   choices = categories, 
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    # Input occasion filter
                                    selectizeInput(inputId = "occasion_filter2",
                                                   label = "Occasions",
                                                   choices = occasion_choices, 
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    width = 2
                                    ),
                                  mainPanel(
                                    # Column with user item purchase history and user brand/category history
                                    column(12, h3("Item Recommendation", align = "center"), br(),
                                           htmlOutput("item_recs2"), br(),
                                           imageOutput("clothing_image"), br(), br(),
                                           actionButton("go", "Pass"),
                                           actionButton("like", "Like"),
                                           align = "center"),br(),
                                    fluidRow(
                                      column(6,h3("Pass"),
                                             htmlOutput("item_passed"),
                                             align="center"),
                                      column(6,h3("Shopping Cart"),
                                             htmlOutput("item_liked"),
                                             align="center")
                                    ),
                                    width = 10
                                  )
                                )
                       ),
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
                                    # Input brand filter
                                    selectizeInput(inputId = "brand_filter",
                                                   label = "Brands",
                                                   choices = brands,
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    # Input category filter
                                    selectizeInput(inputId = "category_filter",
                                                   label = "Categories",
                                                   choices = categories, 
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    # Input occasion filter
                                    selectizeInput(inputId = "occasion_filter",
                                                   label = "Occasions",
                                                   choices = occasion_choices, 
                                                   multiple = TRUE,
                                                   selected = "all"),
                                    # Input number of recommendations
                                    selectizeInput(inputId = "num_recs",
                                                   label = "Number of Recommendations",
                                                   selected = 7,
                                                   choices = c(1:30)),
                                    width = 2
                                  ),
                                  mainPanel(
                                    # By item
                                    fluidRow(column(4, h3("Item Purchase History", align = "center"), br(),
                                                    htmlOutput("user_item_history"),
                                                    align = "center"),
                                             column(8, h3("Item Product Recommendations", align = "center"), br(),
                                                    htmlOutput("item_recs"), br(),
                                                    align = "center")),
                                    # By brand/category
                                    fluidRow(column(4, h3("Brands & Categories History", align = "center"), br(),
                                                    htmlOutput("user_brand_cat_history"),
                                                    align = "center"),
                                             column(8,
                                                    h3("Brands & Categories Recommendations", align = "center"), br(),
                                                    fluidRow(column(6, h4("Excluding previous purchases"), br(),
                                                                    htmlOutput("brand_recs_anti"),
                                                                    align = "center"),
                                                             column(6, h4 ("Including previous purchases"), br(),
                                                                    htmlOutput("brand_recs_known")),
                                                             align = "center"),
                                                    align = "center")
                                    ),
                                    width = 10
                                  )
                                )
                       ),
                       tabPanel("About Us",
                                htmlOutput("contact"))
                       )
            )
)