shinyServer(function(input, output) {
  
  output$user_item_history = renderGvis({
    gvisTable(ratings_product %>%
                filter(., user_id == input$user_id) %>%
                select(., Item, Brand, Category) %>%
                slice(1:input$num_recs))
  })
  
  output$user_brand_cat_history = renderGvis({
    gvisTable(ratings_store_cat %>%
                filter(., User == input$user_id) %>%
                select(., Brand, Category) %>%
                slice(1:input$num_recs))
  })
  
  item_recs_reactive = reactive({
    recs_product[[input$algo]] %>%
      filter(., uid == input$user_id & score_type == "anti") %>%
      arrange(desc(est)) %>%
      select(., Item, Brand, Category)
  })
  
  output$item_recs = renderGvis({
    if ((input$brand_filter != "all") && (input$category_filter != "all")){
      gvisTable(item_recs_reactive() %>% filter(., Brand %in% input$brand_filter, Category %in% input$category_filter) %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter == "all")){
      gvisTable(item_recs_reactive() %>% filter(., Brand %in% input$brand_filter) %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all")){
      gvisTable(item_recs_reactive() %>% filter(., Category %in% input$category_filter) %>% slice(1:input$num_recs))
    } else {
      gvisTable(item_recs_reactive() %>% slice(1:input$num_recs))
    }
    })

  brand_recs_anti_reactive = reactive({
    recs_store_cat[[input$algo]] %>%
      filter(., uid == input$user_id & score_type == "anti") %>%
      arrange(desc(est)) %>%
      select(., Brand, Category)
  })
  output$brand_recs_anti = renderGvis({
    if (input$brand_filter != "all" && input$category_filter != "all"){
      gvisTable(brand_recs_anti_reactive() %>% filter(., Brand %in% input$brand_filter, Category %in% input$category_filter) %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter == "all")){
      gvisTable(brand_recs_anti_reactive() %>% filter(., Brand %in% input$brand_filter) %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all")){
      gvisTable(brand_recs_anti_reactive() %>% filter(., Category %in% input$category_filter) %>% slice(1:input$num_recs))
    } else {
      gvisTable(brand_recs_anti_reactive() %>% slice(1:input$num_recs))
    }
  })

  brand_recs_known_reactive = reactive({
    recs_store_cat[[input$algo]] %>%
      filter(., uid == input$user_id & score_type == "known") %>%
      arrange(desc(est)) %>%
      select(., Brand, Category)
  })
  output$brand_recs_known = renderGvis({
    if ((input$brand_filter != "all") && (input$category_filter != "all")){
      gvisTable(brand_recs_known_reactive() %>% filter(., Brand %in% input$brand_filter, Category %in% input$category_filter) %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter == "all")){
      gvisTable(brand_recs_known_reactive() %>% filter(., Brand %in% input$brand_filter) %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all")){
      gvisTable(brand_recs_known_reactive() %>% filter(., Category %in% input$category_filter) %>% slice(1:input$num_recs))
    } else {
      gvisTable(brand_recs_known_reactive() %>% slice(1:input$num_recs))
    }
  })
  
  
  output$contact = renderUI({
    HTML(paste("Stella Kim is a data scientist with a passion for data analytics, visualization,\
               machine learning, statistical methodology, and programming. Primarily interested \
               in helping businesses make data-driven, customer-centric decisions. <br><br>\
               
               <b>Contact Information</b>:<br>
               Phone: (516) 510-3002<br>
               Email: <a href = 'mailto:stellahkim93@gmail.com'>stellahkim93@gmail.com</a><br>
               <a href = 'https://github.com/stellahkim93'>GitHub</a><br>
               <a href = 'www.linkedin.com/in/stellahkim93'>LinkedIn</a><br>"))
  })
  
})
