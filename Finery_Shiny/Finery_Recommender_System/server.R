shinyServer(function(input, output) {

  output$user_item_history = renderGvis({
    gvisTable(ratings_product %>%
                filter(., user_id == input$user_id) %>%
                select(., Item, Brand, Category) %>%
                unique() %>%
                slice(1:input$num_recs))
  })

  output$user_brand_cat_history = renderGvis({
    gvisTable(ratings_store_cat %>%
                filter(., User == input$user_id) %>%
                select(., Brand, Category) %>%
                unique() %>%
                slice(1:input$num_recs))
  })
  
  item_recs_reactive = reactive({
    recs_product[[input$algo]] %>%
      filter(., uid == input$user_id & score_type == "anti") %>%
      arrange(desc(est)) %>%
      select(., Item, Brand, Category, Occasion)
  })
  
  output$item_recs = renderGvis({
    if ((input$brand_filter != "all") && (input$category_filter != "all") && (input$occasion_filter != "all")){
      gvisTable(item_recs_reactive() %>%
                  filter(., Brand %in% input$brand_filter, Category %in% input$category_filter, Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter != "all") && (input$occasion_filter == "all")){
      gvisTable(item_recs_reactive() %>%
                  filter(., Brand %in% input$brand_filter, Category %in% input$category_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter == "all") && (input$occasion_filter == "all")){
      gvisTable(item_recs_reactive() %>%
                  filter(., Brand %in% input$brand_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all") && (input$occasion_filter != "all")){
      gvisTable(item_recs_reactive() %>%
                  filter(., Category %in% input$category_filter, Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all") && (input$occasion_filter == "all")){
      gvisTable(item_recs_reactive() %>%
                  filter(., Category %in% input$category_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    }  else if ((input$brand_filter == "all") && (input$category_filter == "all") && (input$occasion_filter != "all")){
      gvisTable(item_recs_reactive() %>%
                  filter(., Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else {
      gvisTable(item_recs_reactive() %>% select(., -c("Occasion")) %>% unique() %>% slice(1:input$num_recs),
                options = list(fontSize=20))
    }
    })
  
  item_recs_reactive2 = reactive({
    recs_product[[input$algo2]] %>%
      filter(., uid == input$user_id2 & score_type == "anti") %>%
      arrange(desc(est)) %>%
      select(., Item, Brand, Category, Occasion, `Category ID`)
  })
  
  i_rec = reactiveVal(1)
  
  item_recs_reactive3 = reactive({
    recs_product[[input$algo2]] %>%
      filter(., uid == input$user_id2 & score_type == "anti") %>%
      arrange(desc(est)) %>%
      select(., uid, Item, Brand, Category, Occasion)
  })
  
  item_psed = reactive({
    if ((input$brand_filter2 != "all") && (input$category_filter2 != "all") && (input$occasion_filter2 != "all")){
      item_recs_reactive3() %>%
        filter(., Brand %in% input$brand_filter2, Category %in% input$category_filter2, Occasion %in% input$occasion_filter2) %>% 
        select(., -c("Occasion")) %>%
        unique() %>% slice(1:i_rec())
    } else if ((input$brand_filter2 != "all") && (input$category_filter2 != "all") && (input$occasion_filter2 == "all")){
      item_recs_reactive3() %>%
        filter(., Brand %in% input$brand_filter2, Category %in% input$category_filter2) %>% 
        select(., -c("Occasion")) %>%
        unique() %>% slice(1:i_rec())
    } else if ((input$brand_filter2 != "all") && (input$category_filter2 == "all") && (input$occasion_filter2 == "all")){
      item_recs_reactive3() %>%
        filter(., Brand %in% input$brand_filter2) %>% 
        select(., -c("Occasion")) %>%
        unique() %>% slice(1:i_rec())
    } else if ((input$brand_filter2 == "all") && (input$category_filter2 != "all") && (input$occasion_filter2 != "all")){
      item_recs_reactive3() %>%
        filter(., Category %in% input$category_filter2, Occasion %in% input$occasion_filter2) %>% 
        select(., -c("Occasion")) %>%
        unique() %>% slice(1:i_rec())
    } else if ((input$brand_filter2 == "all") && (input$category_filter2 != "all") && (input$occasion_filter2 == "all")){
      item_recs_reactive3() %>%
        filter(., Category %in% input$category_filter2) %>% 
        select(., -c("Occasion")) %>%
        unique() %>% slice(1:i_rec())
    }  else if ((input$brand_filter2 == "all") && (input$category_filter2 == "all") && (input$occasion_filter2 != "all")){
      item_recs_reactive3() %>%
        filter(., Occasion %in% input$occasion_filter2) %>% 
        select(., -c("Occasion")) %>%
        unique() %>% slice(1:i_rec())
    } else {
      item_recs_reactive3() %>% select(., -c("Occasion")) %>% unique() %>% slice(1:i_rec())
    }
  })
  
  observeEvent(input$go, {
    newValue = i_rec() + 1
    i_rec(newValue)
    old_value = passed_items()
    new_value = head(tail(item_psed(),2),1)
    trash_df = rbind(old_value, new_value)
    passed_items(trash_df)
  })
  
  observeEvent(input$like, {
    newValue = i_rec() + 1
    i_rec(newValue)
    old_value = liked_items()
    new_value = tail(item_psed(),1)
    liked_df = rbind(old_value, new_value)
    liked_items(liked_df)
  })
  
  passed_items = reactiveVal(data.frame(uid = numeric(),
                                        Item = character(),
                                        Brand = character(),
                                        Category = character()))
  
  liked_items = reactiveVal(data.frame(uid = numeric(),
                                       Item = character(),
                                       Brand = character(),
                                       Category = character()))
  
  output$item_passed = renderGvis(
    gvisTable(passed_items())
  )
  
  output$item_liked = renderGvis(
    gvisTable(liked_items())
  )
  
  output$clothing_image = renderImage({
    if ((input$brand_filter2 != "all") && (input$category_filter2 != "all") && (input$occasion_filter2 != "all")){
      filename = normalizePath(file.path("./images",
                                         paste0(item_recs_reactive2() %>%
                                                  filter(., Brand %in% input$brand_filter2, Category %in% input$category_filter2, Occasion %in% input$occasion_filter2) %>% 
                                                  select(., -c("Occasion")) %>% 
                                                  unique() %>% slice(i_rec()) %>% 
                                                  pull(`Category ID`), ".jpg")))
    } else if ((input$brand_filter2 != "all") && (input$category_filter2 != "all") && (input$occasion_filter2 == "all")){
      filename = normalizePath(file.path("./images",
                                         paste0(item_recs_reactive2() %>%
                                                  filter(., Brand %in% input$brand_filter2, Category %in% input$category_filter2) %>% 
                                                  select(., -c("Occasion")) %>% 
                                                  unique() %>% slice(i_rec()) %>% 
                                                  pull(`Category ID`), ".jpg")))
    } else if ((input$brand_filter2 != "all") && (input$category_filter2 == "all") && (input$occasion_filter2 == "all")){
      filename = normalizePath(file.path("./images",
                                         paste0(item_recs_reactive2() %>%
                                                  filter(., Brand %in% input$brand_filter2) %>% 
                                                  select(., -c("Occasion")) %>% 
                                                  unique() %>% slice(i_rec()) %>% 
                                                  pull(`Category ID`), ".jpg")))
    } else if ((input$brand_filter2 == "all") && (input$category_filter2 != "all") && (input$occasion_filter2 != "all")){
      filename = normalizePath(file.path("./images",
                                         paste0(item_recs_reactive2() %>%
                                                  filter(., Category %in% input$category_filter2, Occasion %in% input$occasion_filter2) %>% 
                                                  select(., -c("Occasion")) %>% 
                                                  unique() %>% slice(i_rec()) %>% 
                                                  pull(`Category ID`), ".jpg")))
    } else if ((input$brand_filter2 == "all") && (input$category_filter2 != "all") && (input$occasion_filter2 == "all")){
      filename = normalizePath(file.path("./images",
                                         paste0(item_recs_reactive2() %>%
                                                  filter(., Category %in% input$category_filter2) %>% 
                                                  select(., -c("Occasion")) %>% 
                                                  unique() %>% slice(i_rec()) %>% 
                                                  pull(`Category ID`), ".jpg")))
    }  else if ((input$brand_filter2 == "all") && (input$category_filter2 == "all") && (input$occasion_filter2 != "all")){
      filename = normalizePath(file.path("./images",
                                         paste0(item_recs_reactive2() %>%
                                                  filter(., Occasion %in% input$occasion_filter2) %>%
                                                  select(., -c("Occasion")) %>% 
                                                  unique() %>% slice(i_rec()) %>% 
                                                  pull(`Category ID`), ".jpg")))
    } else {
      filename = normalizePath(file.path("./images",
                                         paste0(item_recs_reactive2() %>%
                                                  select(., -c("Occasion")) %>% 
                                                  unique() %>% slice(i_rec()) %>% 
                                                  pull(`Category ID`), ".jpg")))
    }
    list(src = filename, width = "30%")
  }, deleteFile = FALSE)
  
  output$item_recs2 = renderGvis({
    if ((input$brand_filter2 != "all") && (input$category_filter2 != "all") && (input$occasion_filter2 != "all")){
      gvisTable(item_recs_reactive2() %>%
                  filter(., Brand %in% input$brand_filter2, Category %in% input$category_filter2, Occasion %in% input$occasion_filter2) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(i_rec()))
    } else if ((input$brand_filter2 != "all") && (input$category_filter2 != "all") && (input$occasion_filter2 == "all")){
      gvisTable(item_recs_reactive2() %>%
                  filter(., Brand %in% input$brand_filter2, Category %in% input$category_filter2) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(i_rec()))
    } else if ((input$brand_filter2 != "all") && (input$category_filter2 == "all") && (input$occasion_filter2 == "all")){
      gvisTable(item_recs_reactive2() %>%
                  filter(., Brand %in% input$brand_filter2) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(i_rec()))
    } else if ((input$brand_filter2 == "all") && (input$category_filter2 != "all") && (input$occasion_filter2 != "all")){
      gvisTable(item_recs_reactive2() %>%
                  filter(., Category %in% input$category_filter2, Occasion %in% input$occasion_filter2) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(i_rec()))
    } else if ((input$brand_filter2 == "all") && (input$category_filter2 != "all") && (input$occasion_filter2 == "all")){
      gvisTable(item_recs_reactive2() %>%
                  filter(., Category %in% input$category_filter2) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(i_rec()))
    }  else if ((input$brand_filter2 == "all") && (input$category_filter2 == "all") && (input$occasion_filter2 != "all")){
      gvisTable(item_recs_reactive2() %>%
                  filter(., Occasion %in% input$occasion_filter2) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(i_rec()))
    } else {
      gvisTable(item_recs_reactive2() %>% select(., -c("Occasion")) %>% unique() %>% slice(i_rec()))
    }
  })

  brand_recs_anti_reactive = reactive({
    recs_store_cat[[input$algo]] %>%
      filter(., uid == input$user_id & score_type == "anti") %>%
      arrange(desc(est)) %>%
      select(., Brand, Category, Occasion)
  })
  
  output$brand_recs_anti = renderGvis({
    if ((input$brand_filter != "all") && (input$category_filter != "all") && (input$occasion_filter != "all")){
      gvisTable(brand_recs_anti_reactive() %>%
                  filter(., Brand %in% input$brand_filter, Category %in% input$category_filter, Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter != "all") && (input$occasion_filter == "all")){
      gvisTable(brand_recs_anti_reactive() %>%
                  filter(., Brand %in% input$brand_filter, Category %in% input$category_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter == "all") && (input$occasion_filter == "all")){
      gvisTable(brand_recs_anti_reactive() %>%
                  filter(., Brand %in% input$brand_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all") && (input$occasion_filter != "all")){
      gvisTable(brand_recs_anti_reactive() %>%
                  filter(., Category %in% input$category_filter, Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all") && (input$occasion_filter == "all")){
      gvisTable(brand_recs_anti_reactive() %>%
                  filter(., Category %in% input$category_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    }  else if ((input$brand_filter == "all") && (input$category_filter == "all") && (input$occasion_filter != "all")){
      gvisTable(brand_recs_anti_reactive() %>%
                  filter(., Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else {
      gvisTable(brand_recs_anti_reactive() %>% select(., -c("Occasion")) %>% unique() %>% slice(1:input$num_recs))
    }
  })

  brand_recs_known_reactive = reactive({
    recs_store_cat[[input$algo]] %>%
      filter(., uid == input$user_id & score_type == "known") %>%
      arrange(desc(est)) %>%
      select(., Brand, Category, Occasion)
  })
  output$brand_recs_known = renderGvis({
    if ((input$brand_filter != "all") && (input$category_filter != "all") && (input$occasion_filter != "all")){
      gvisTable(brand_recs_known_reactive() %>%
                  filter(., Brand %in% input$brand_filter, Category %in% input$category_filter, Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter != "all") && (input$occasion_filter == "all")){
      gvisTable(brand_recs_known_reactive() %>%
                  filter(., Brand %in% input$brand_filter, Category %in% input$category_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter != "all") && (input$category_filter == "all") && (input$occasion_filter == "all")){
      gvisTable(brand_recs_known_reactive() %>%
                  filter(., Brand %in% input$brand_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all") && (input$occasion_filter != "all")){
      gvisTable(brand_recs_known_reactive() %>%
                  filter(., Category %in% input$category_filter, Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else if ((input$brand_filter == "all") && (input$category_filter != "all") && (input$occasion_filter == "all")){
      gvisTable(brand_recs_known_reactive() %>%
                  filter(., Category %in% input$category_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    }  else if ((input$brand_filter == "all") && (input$category_filter == "all") && (input$occasion_filter != "all")){
      gvisTable(brand_recs_known_reactive() %>%
                  filter(., Occasion %in% input$occasion_filter) %>% 
                  select(., -c("Occasion")) %>%
                  unique() %>% slice(1:input$num_recs))
    } else {
      gvisTable(brand_recs_known_reactive() %>% select(., -c("Occasion")) %>% unique() %>% slice(1:input$num_recs))
    }
  })
  
  
  output$contact = renderUI({
    HTML("
        <b>Stella Kim</b> is a data scientist with 4 years of experience using R, with
        a Master's in Biotechnology and PhD experience in Cancer Biology and Computational
        Genomics. Proficient in R, Python, and SQL. Passionate about data analytics, visualization,
        machine learning, statistical methodology, and programming. Interested in helping
        businesses make data-driven, customer-centric decisions. <br>
        <b>Contact Information</b>:<br>
        Phone: (516) 510-3002<br>
        <a href = 'mailto:stellahkim93@gmail.com'>stellahkim93@gmail.com</a><br>
        <a href = 'https://github.com/stellahkim93'>GitHub</a><br>
        <a href = 'www.linkedin.com/in/stellahkim93'>LinkedIn</a><br><br><br>

        <b>Mimi Chung</b> is an aspiring data analyst with experience in the chemical and
        innovative material science industry as an associate engineer. Previously, she has
        worked across multiple functions to research, develop and sell conductive materials.
        She has experience in data analysis, web scraping with Python, data visualization in R,
        and predictive modeling utilizing several machine learning methods. <br>
        <b>Contact Information</b>:<br>
        <a href = 'mailto:minchung91@gmail.com'>minchung91@gmail.com</a><br>
        <a href = 'https://github.com/minchung91'>GitHub</a><br>
        <a href = 'https://www.linkedin.com/in/mimichung215/'>LinkedIn</a><br><br><br>
         
        <b>Radha Murali Vundavalli</b><br>
        <a href = 'mailto:vrmk@hotmail.com'>vrmk@hotmail.com</a><br>
        <a href = 'https://www.linkedin.com/in/radhamurali/'>LinkedIn</a><br><br><br>
        
        <b>Qifan Wang</b><br>
        <a href = 'mailto:wqf995@gmail.com'>wqf995@gmail.com</a><br>
        <a href = 'https://www.linkedin.com/in/qifanw/'>LinkedIn</a><br>
         ")
  })
  
})
