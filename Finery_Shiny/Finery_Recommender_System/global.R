library(shiny)
library(tidyverse)
library(data.table)
library(shinythemes)
library(RColorBrewer)
library(ggthemes)
library(googleVis)
suppressPackageStartupMessages(library(googleVis))

items = fread("./data/items.csv")
items = items %>% mutate(., user_id = as.numeric(user_id)) %>%
  select(., user_id, store_id, product_id, "Item" = item_name_lower, "Category" = `Category Name`) %>% rename(., "brand_id" = store_id)
occasions = fread("./data/occasions.csv")
occasions = occasions %>% rename(., "Occasion" = occassion)
occasion_choices = c("all", unique(occasions$Occasion))
items = left_join(items, occasions, by = c("Category" = "category"))
ratings = fread("./data/rating_subset.csv")
ratings = ratings %>% mutate(., user_id = as.numeric(user_id)) %>% arrange(user_id, desc(rating)) %>% rename(., "Rating" = rating)
ratings_product = ratings %>% filter(., base == "product")
ratings_product = left_join(ratings_product, items, by = c("user_id", "product_id")) %>% rename(., "Brand" = brand_id) %>% unique

ratings_store_cat = ratings %>% filter(., base == "store_cat")
ratings_store_cat = ratings_store_cat %>%
  transmute(., User = user_id,
            Brand = sapply(sapply(ratings_store_cat$product_id, str_split, " - "), function(l) l[1]),
            Category = sapply(sapply(ratings_store_cat$product_id, str_split, " - "), function(l) l[3]),
            Rating = Rating)

recs = list()
algos = str_remove(str_remove(dir("./data/algo/"), "subset_reco_scores_"), ".csv")
for (i in algos){
  recs[[i]] = fread(paste0("./data/algo/subset_reco_scores_", i, ".csv"))
  recs[[i]] = recs[[i]] %>% mutate(., uid = as.numeric(uid)) %>% arrange(uid, desc(est))
}

recs [["LightFM_Basic"]] = recs[["LightFM_Basic"]] %>% mutate(., base = str_replace(base, "-", "_"))

occs = items %>% select(., brand_id, product_id, Item, Category, Occasion)

recs_product = list()
for (i in algos){
  recs_product[[i]] = recs[[i]] %>% filter(., base == "product", score_type == "anti")
  recs_product[[i]] = left_join(recs_product[[i]], occs, by = c("iid" = "product_id")) %>%
    select(., uid, iid, est, base, score_type, Brand = brand_id, Item, Category, Occasion) %>% unique()
}

recs_store_cat = list()
for (i in algos){
  recs_store_cat[[i]] = recs[[i]] %>% filter(., base == "store_cat")
  recs_store_cat[[i]] = recs_store_cat[[i]] %>% transmute(., uid, iid, est, base, score_type, 
                                    Brand = sapply(sapply(recs_store_cat[[i]]$iid, str_split, " - "), function(l) l[1]),
                                    Category = sapply(sapply(recs_store_cat[[i]]$iid, str_split, " - "), function(l) l[3])) %>% unique()
  recs_store_cat[[i]] = left_join(recs_store_cat[[i]], occasions, by = c("Category" = "category"))
}

user_ids = unique(ratings$user_id)
brands = c("all",unique(items$brand_id))
categories = c("all", unique(items$Category))







