library(tidyverse)
library(furrr)
library(snakecase)

plan(multisession, workers = 7)

boardgames_overview <- readRDS("data/boardgames_overview.RDS")

boardgames_overview <- boardgames_overview %>%
  mutate(link = link %>% str_c("https://boardgamegeek.com", .),
         fn = rank %>%
           str_pad(4, "left", 0) %>%
           str_c(., "_", title %>% to_snake_case()) %>%
           str_c("data/html/", . , ".html")
         )

future_walk(1:nrow(boardgames_overview), function(i){
  f <- read_file(boardgames_overview$link[i])
  write_file(f, boardgames_overview$fn[i])
}, .progress = TRUE)


