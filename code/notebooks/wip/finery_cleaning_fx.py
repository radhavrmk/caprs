#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 16 16:03:44 2019

@author: stellakim
"""

import pandas as pd
import numpy as np

#cd Documents/NYC\ Data\ Science\ Academy/Finery

###############################################################################
############################### ITEM SUBSET ###################################
###############################################################################
# Read in item subset, only keep columns of interest.
item_subset = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "8. item_subset")
item_subset2 = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "15. 100_users_item_set")
item_subset = pd.concat([item_subset, item_subset2], axis = 0, ignore_index = True)
del item_subset2

def keep_relevant_item_cols(df):
    keep_cols = ["user_id", "brand_id", "user_provided_brand_name",
             "parsed_brand_name", "store_id", "user_provided_store_name", "parsed_store_name",
             "product_id", "item_name_lower", "product_category_id", "paid_price", 
             "list_price", "sale_price", "size", "email_dt", "color_parsed", "is_returned"]
    df = df[keep_cols]
    return df
item_subset = keep_relevant_item_cols(item_subset)

# Reading in category_id
category_ids = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "9. category_ids").dropna()
cat_id = category_ids["Category ID"]

# Reading in colors
reference_color = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "2. reference_color")
ref_colors = reference_color["colorname0"].unique()

# Drop rows in product_category_id that do not contain proper category ID.
def clean_product_category_id(df):
	df = df.loc[df["product_category_id"].isin(cat_id)]
	return df
item_subset = clean_product_category_id(item_subset)

# Drop rows with missing item_name_lower.
def clean_missing_items(df):
	df = df.loc[df["item_name_lower"].notna()]
	return df
item_subset = clean_missing_items(item_subset)

# Drop rows with misc items (category ID >= 600)
def clean_misc_items(df):
    df = df.loc[df["product_category_id"] < 600]
    return df
item_subset = clean_misc_items(item_subset)

# Cleaning up size and color for beauty products (category IDs 500-560)
def clean_beauty_products(df):
    df.loc[(df["product_category_id"] >= 500) & (df["product_category_id"] <= 560), ["size", "color_parsed"]] = "NA"
    return df
item_subset = clean_beauty_products(item_subset)

# Keep "brand_id" and filling in missing values from "user_provided_brand_name" or "parsed_brand_name".
item_subset.loc[item_subset["user_provided_brand_name"] == "Franco Satro", "user_provided_brand_name"] = "Franco Sarto"
def clean_brand_id(df):
    df["brand_id"].fillna(df["user_provided_brand_name"].str.lower().str.replace('[^\w]',''), inplace = True)
    df["brand_id"].fillna(df["parsed_brand_name"].str.lower().str.replace('[^\w]',''), inplace = True)
    df.drop(columns = ["user_provided_brand_name", "parsed_brand_name"], inplace = True)
    return df
item_subset = clean_brand_id(item_subset)


# Keep "store_id" and filling in missing values from "parsed_store_name".
def clean_store_id(df):
    df["store_id"].fillna(df["user_provided_store_name"].str.lower().str.replace('[^\w]',''), inplace = True)
    df["store_id"].fillna(df["parsed_store_name"].str.lower().str.replace('[^\w]',''), inplace = True)
    df["store_id"].fillna(df["brand_id"], inplace = True)
    df.drop(columns = ["brand_id", "user_provided_store_name", "parsed_store_name"], inplace = True)
    return df
item_subset = clean_store_id(item_subset)

# Convert sale_price to binary (0 for non-sale, 1 for sale)
def clean_sale_price(df):
    df["sale_price"] = [0 if price == 0 else 1 for price in df["sale_price"]]
    return df
item_subset = clean_sale_price(item_subset)

# Convert is_returned to binary (0 for not returned, 1 for returned)
def clean_is_returned(df):
    df["is_returned"] = [0 if returned == False else 1 for returned in df["is_returned"]]
    return df
item_subset = clean_is_returned(item_subset)

# Drop rows if price is missing
def clean_price(df):
    df = df.loc[df['paid_price'] > 0]
    return df
item_subset = clean_price(item_subset)

# Drop rows if product_id is missing
def clean_product_id(df):
    df = df.loc[df['product_id'].notna()]
    return df
item_subset = clean_product_id(item_subset)

# Sizes
x = []
for item in item_subset["item_name_lower"].str.replace('[^\w]','').str.replace('[\d]', ''):
    for size in ["tall", "petite", "maternity"]:
        if item.find("metallic") == -1:
            if item.find(size) != -1:
                x.append({item: size})
                
y = item_subset.replace(x)


### Colors
##
##raw_color_rules = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "5. influencer_color_rules", header = None)
##col_pairs = list(zip(np.arange(0, 23, 3), np.arange(1, 23, 3)))
##color_rules = pd.DataFrame()
##for col in col_pairs:
##    color_rules = pd.concat([color_rules, raw_color_rules.loc[0:11, col]], axis = 1)
##raw_color_rules = raw_color_rules.loc[13:,].reset_index(drop = True)
##
##col_pairs = list(zip(np.arange(0, 8, 3), np.arange(1, 8, 3)))
##for col in col_pairs:
##    color_rules = pd.concat([color_rules, raw_color_rules.loc[0:11, col]], axis = 1)
##raw_color_rules = raw_color_rules.loc[13:,].reset_index(drop = True)
##
##col_pairs = list(zip(np.arange(0, 20, 3), np.arange(1, 20, 3)))
##for col in col_pairs:
##    color_rules = pd.concat([color_rules, raw_color_rules.loc[0:11, col]], axis = 1)
##raw_color_rules = raw_color_rules.loc[13:,].reset_index(drop = True)
##
##del raw_color_rules
##
##color_rules.loc[0,:].fillna("count", inplace = True)
##color_rules.drop(index = 1, inplace = True)
#
#
## Should we remove colors?
#x = []
#for item in item_subset["item_name_lower"].str.replace('[^\w]','').str.replace('[\d]', ''):
#    for color in ref_colors:
#        if item.find("tank") == -1:
#            if item.find(color) != -1:
#                x.append([item, color])
#item_subset["item_name_lower"].isin(ref_colors).sum()
#x = item_subset["color_parsed"].str.lower().str.replace('[^\w\s]','').str.replace('[\d]', '')
#
#
#item_subset["item_name_lower"].isin(ref_colors).sum()
#
#x.isin(ref_colors).sum()
#
#len(item_subset["color_parsed"].str.lower().str.replace('[^\w\s]','').str.replace('[\d]', '').unique())
#item_subset["color_parsed"].str.lower().str.replace('[^\w\s]','').str.replace('[\d]', '').value_counts()

###############################################################################
############################### USER SUBSET ###################################
###############################################################################
user_subset = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "7. user_subset")
user_subset2 = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "14. 100_users_set")
user_subset = pd.concat([user_subset, user_subset2], axis = 0, ignore_index = True)
del user_subset2

def keep_relevant_user_cols(df):
    keep_cols = ["user_id", "style_age_range", "location_latitude",
                 "location_longitude", "style_size_preference_petite",
                 "style_size_preference_extra_long", "style_size_preference_plus",
                 "style_size_preference_maternity", "has_stype_vibe", "style_who_inspiries_skipped",
                 "style_most_important_active", "style_most_important_any",
                 "style_most_important_beach", "style_most_important_dress",
                 "style_most_important_bags", "style_most_important_jeans",
                 "style_most_important_jump", "style_most_important_nothing",
                 "style_most_important_outwear", "style_most_important_pants",
                 "style_most_important_shoes", "style_most_important_tops",
                 "style_shopping_pref_gaps", "style_shopping_pref_other",
                 "style_shopping_pref_trips", "style_shopping_pref_events",
                 "style_shopping_pref_work", "style_shopping_pref_wish",
                 "style_shopping_pref_organize", "style_shopping_pref_inspo"]
    df = df[keep_cols]
    return df
user_subset = keep_relevant_user_cols(user_subset)

def clean_style_age_range_group(df):
    missing_age_idx = df[df["style_age_range"].isna()].index
    for missing_age in missing_age_idx:
        df.loc[missing_age, "style_age_range"] = np.random.choice(df.loc[user_subset["style_age_range"].notna(), "style_age_range"])
    return df
user_subset = clean_style_age_range_group(user_subset)

def clean_has_stype_vibe(df):
    df["has_stype_vibe"] = [0 if pref == False else 1 for pref in df["has_stype_vibe"]]
    return df
user_subset = clean_has_stype_vibe(user_subset)

def clean_style_who_inspiries_skipped(df):
    df["style_who_inspiries_skipped"] = [0 if pref == False else 1 for pref in df["style_who_inspiries_skipped"]]
    return df
user_subset = clean_style_who_inspiries_skipped(user_subset)

style_cols = user_subset.columns[user_subset.columns.str.startswith("style")]
for col in style_cols:
    user_subset[col].fillna(0, inplace = True)


user_subset.loc[3, "location_latitude"] == user_subset["location_latitude"]

np.random.choice(user_subset.loc[user_subset["location_latitude"].notna(), "location_latitude"])


###############################################################################
############################# WISHLIST ITEMS ##################################
###############################################################################
wishlist_items = pd.read_excel("./data/Finery_X_NYCDSA_UI_of_the_Future.xlsx", sheet_name = "12. wishlist_items")

def keep_relevant_wishlist_cols(df):
    keep_cols = ["userid", "itemid", "itemname_lower", "store_lower",
                 "itemcategory", "source", "price"]
    df = df[keep_cols]
    return df

wishlist_items = keep_relevant_wishlist_cols(wishlist_items)

# Drop rows with missing category ID
def clean_missing_cat_id(df):
    df = df.loc[df["itemcategory"] < 600]
    return df
wishlist_items = clean_missing_cat_id(wishlist_items)

# Remove rows with no store name and remove spaces and characters
def clean_wishlist_store(df):
    df = df.loc[df["store_lower"].notna()]
    return df
wishlist_items = clean_wishlist_store(wishlist_items)
wishlist_items["store_lower"].replace('[^\w]','', regex = True, inplace = True)

def clean_likes(df):
    df['like'] = [0 if like == "onboarding_dislike" else 1 for like in df["source"]]
    df.drop(columns = ["source"], inplace = True)
    return df
wishlist_items = clean_likes(wishlist_items)



















