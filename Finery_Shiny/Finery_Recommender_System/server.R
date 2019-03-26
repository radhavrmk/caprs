shinyServer(function(input, output) {
  #output$contact
  output$user_item_history = renderGvis({
    gvisTable(ratings %>%
                filter(., user_id == input$user_id & base == "product") %>%
                arrange(desc(rating)) %>%
                select(., product_id, rating) %>%
                slice(1:input$num_recs))
  })
  
  output$user_brand_cat_history = renderGvis({
    gvisTable(ratings %>%
                filter(., user_id == input$user_id & base == "store_cat") %>%
                arrange(desc(rating)) %>%
                transmute(.,
                          "Brand" = str_split(product_id, " - ")[[1]][1],
                          "Category" = str_split(product_id, " - ")[[1]][3],
                          "Rating" = rating) %>%
                slice(1:input$num_recs))
  })
  
  output$item_recs = renderGvis({
    gvisTable(recs %>%
                filter(., uid == input$user_id & base == "product" & algorithm == input$algorithm) %>%
                arrange(desc(est)) %>%
                select(., iid, est) %>%
                slice(1:input$num_recs))
  })
  
  
  output$brand_recs_anti = renderGvis({
    gvisTable(recs %>%
                filter(., uid == input$user_id & base == "store_cat" & score_type == "anti" & algorithm == input$algorithm) %>%
                arrange(desc(est)) %>%
                transmute(.,
                          "Brand" = str_split(iid, " - ")[[1]][1],
                          "Category" = str_split(iid, " - ")[[1]][3],
                          "Rating" = est) %>%
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
