shinyServer(function(input, output) {
  #output$contact
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
  
  output$item_recs = renderGvis({
    gvisTable(recs[[input$algo]] %>%
                filter(., uid == input$user_id & base == "product") %>%
                arrange(desc(est)) %>%
                select(., iid) %>%
                slice(1:input$num_recs))
  })

  output$brand_recs_anti = renderGvis({
    gvisTable(recs[[input$algo]] %>%
                filter(., uid == input$user_id & base == "store_cat" & score_type == "anti") %>%
                arrange(desc(est)) %>%
                select(., iid) %>%
                slice(1:input$num_recs))
  })

  output$brand_recs_known = renderGvis({
    gvisTable(recs[[input$algo]] %>%
                filter(., uid == input$user_id & base == "store_cat" & score_type == "known") %>%
                arrange(desc(est)) %>%
                select(., iid) %>%
                slice(1:input$num_recs))
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
