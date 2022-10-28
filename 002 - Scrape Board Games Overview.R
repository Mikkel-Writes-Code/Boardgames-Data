# Load libraries
library(tidyverse)
library(rvest)
library(snakecase)

## Read in HTML data

url <- "https://boardgamegeek.com/browse/boardgame"

html_data <- read_html(url)

## Read in table from a website

df <- html_data %>%
  html_node("table") %>%
  html_table() %>%
  set_names(names(.) %>% to_snake_case()) %>%
  mutate(board_game_rank = board_game_rank %>% as.integer(),
         geek_rating = geek_rating %>% as.numeric(),
         avg_rating = avg_rating %>% as.numeric(),
         num_voters = num_voters %>% as.integer(),
         title = title %>% str_squish()) %>%
  select(-thumbnail_image, -shop) %>%
  drop_na()

## Get more specific data from a wesite

html_data <- read_html(url)

rows <- html_data %>% html_nodes("#row_")

df <- map_dfr(rows, function(row){
  rank <- row %>%
    html_node(".collection_rank") %>%
    html_text() %>%
    str_squish() %>%
    as.integer()
  
  thumbnail <- row %>%
    html_node(".collection_thumbnail") %>%
    html_node("img") %>%
    html_attr("src")
  
  title <- row %>%
    html_node(".primary") %>%
    html_text() %>%
    str_squish()
  
  year <- row %>%
    html_node(".smallerfont") %>%
    html_text() %>%
    str_squish() %>%
    str_remove_all("[()]") %>%
    as.integer()
  
  description <- row %>%
    html_node(".smallefont") %>%
    html_text() %>%
    str_squish() 
  
  ratings <- row %>%
    html_nodes(".collection_bggrating") %>%
    html_text() %>%
    str_squish()
  
  geek_rating <- ratings[1] %>% as.numeric()
  avg_rating <- ratings[2] %>% as.numeric()
  num_voters <- ratings[3] %>% as.integer()
  
  link <- row %>%
    html_node(".primary") %>%
    html_attr("href")
  
  tibble(rank, title, year, description, geek_rating, avg_rating, num_voters, thumbnail, link)
  
})
  
## Create a function and loop over pages

base_url <- "https://boardgamegeek.com/browse/boardgame/page/{page}"

parse_overview_page <- function(url){
  html_data <- read_html(url)
  
  rows <- html_data %>% html_nodes("#row_")
  
  df <- map_dfr(rows, function(row){
    rank <- row %>%
      html_node(".collection_rank") %>%
      html_text() %>%
      str_squish() %>%
      as.integer()
    
    thumbnail <- row %>%
      html_node(".collection_thumbnail") %>%
      html_node("img") %>%
      html_attr("src")
    
    title <- row %>%
      html_node(".primary") %>%
      html_text() %>%
      str_squish()
    
    year <- row %>%
      html_node(".smallerfont") %>%
      html_text() %>%
      str_squish() %>%
      str_remove_all("[()]") %>%
      as.integer()
    
    description <- row %>%
      html_node(".smallefont") %>%
      html_text() %>%
      str_squish() 
    
    ratings <- row %>%
      html_nodes(".collection_bggrating") %>%
      html_text() %>%
      str_squish()
    
    geek_rating <- ratings[1] %>% as.numeric()
    avg_rating <- ratings[2] %>% as.numeric()
    num_voters <- ratings[3] %>% as.integer()
    
    link <- row %>%
      html_node(".primary") %>%
      html_attr("href")
    
    tibble(rank, title, year, description, geek_rating, avg_rating, num_voters, thumbnail, link)
    
  })
  
  df
}

pages <- 1:20

pb <- progress::progress_bar$new(total = max(pages))

all_boardgames_overview <- map_dfr(pages, function(page){
  pb$tick()
  
  url <- glue::glue(base_url)
  
  parse_overview_page(url)
})

all_boardgames_overview %>%
  distinct() %>%
  write_rds("boardgames_overview.RDS")
