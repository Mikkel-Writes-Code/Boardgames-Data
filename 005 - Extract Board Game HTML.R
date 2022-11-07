library(tidyverse)
library(rvest)
library(furrr)

plan(multisession, workers = 7)

files <- list.files("data/html", full.names = TRUE)

file <- files %>% sample(1)

future_walk(files, function(file){
  html_data <- read_html(file)
  
  script <- html_data %>%
    html_nodes("script") %>%
    as.character() %>%
    str_subset("GEEK.geekitemPreload")
  
  text <- script %>%
    str_extract("GEEK.geekitemPreload.+") %>%
    str_remove("GEEK.geekitemPreload = ") %>%
    str_remove(";$")
  
  json_data <- text %>% jsonlite::parse_json()
  
  fn <- file %>% str_replace_all("html", "rds")
  
  write_rds(json_data, fn)
}, .progress = TRUE)

