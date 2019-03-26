library(shiny)
library(tidyverse)
library(data.table)
library(lubridate)
library(shinythemes)
library(plotly)
library(RColorBrewer)
library(ggthemes)
library(shinydashboard)
library(googleVis)

items = fread("./data/items.csv")
items = items %>% mutate(., user_id = as.numeric(user_id))
items = items %>%
  select(., user_id, store_id, product_id, "Item" = item_name_lower, "Category" = `Category Name`) %>%
  rename(., "brand_id" = store_id)
ratings = fread("./data/all_ratings.csv")
ratings = ratings %>% mutate(., user_id = as.numeric(user_id))
ratings = ratings %>% arrange(user_id, desc(rating)) %>% rename(., "Rating" = rating)
ratings_product = ratings %>% filter(., base == "product")
ratings_product = left_join(ratings_product, items, by = c("user_id", "product_id")) %>% rename(., "Brand" = brand_id) %>% unique

ratings_store_cat = ratings %>% filter(., base == "store_cat")
ratings_store_cat = ratings_store_cat %>%
  transmute(., User = user_id,
            Brand = sapply(sapply(ratings_store_cat$product_id, str_split, " - "), function(l) l[1]),
            Category = sapply(sapply(ratings_store_cat$product_id, str_split, " - "), function(l) l[3]),
            Rating = Rating)
#recs = fread("./data/all_reco_scores.csv")
recs = list()
algos = sapply(str_split(sapply(str_split(dir("./data/algo"), "_"), function(l) l[4]), "\\."), function(l) l[1])
for (i in algos){
  recs[[i]] = fread(paste0("./data/algo/all_reco_scores_", i, ".csv"))
  recs[[i]] = recs[[i]] %>% mutate(., uid = as.numeric(uid))
  recs[[i]] = recs[[i]] %>% arrange(uid, desc(est))
}

recs_product = list()
for (i in algos){
  recs_product[[i]] = recs[[i]] %>% filter(., base == "product")
  #left_join(recs_product[[i]], items, by = c("user_id", "product_id")) %>% rename(., "Brand" = brand_id) %>% unique
}

#head(left_join(recs_product[[1]], items, by = c("uid" = "user_id", "iid" = "product_id")) %>% rename(., "Brand" = brand_id) %>% unique())



recs_store_cat = list()
for (i in algos){
  recs_store_cat[[i]] = recs[[i]] %>% filter(., base == "store_cat")
}


#recs %>% arrange(uid, desc(est))
#recs$uid = as.numeric(recs$uid)

items = fread("./data/items.csv")

user_ids = unique(ratings$user_id)
