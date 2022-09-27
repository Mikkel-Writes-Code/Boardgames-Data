library(tidyverse)
library(rvest)

HTML <-   '<!DOCTYPE html>
   <html>
   
     <head>
     <title>Capitals of the World</title>
     </head>
     
     <body>
    
        <!-- An element with a unique id -->
        <h1 id="myHeader">My Cities</h1>
        
        <!-- Multiple elements with same class -->
        <h2 id="uk" class="cities_in_europe">London</h2>
        <p>London is the capital of England.</p>
        
        <h2 id="france" class="cities_in_europe">Paris</h2>
        <p>Paris is the capital of France.</p>
        
        <h2 id="japan" class="cities_in_asia">Tokyo</h2>
        <p>Tokyo is the capital of Japan.</p>
    
     </body>
   </html>'

html_data <- read_html(HTML)

# Tags

html_data %>%
  html_node("title") %>%
  html_text()

html_data %>%
  html_node("h2") %>%
  html_text()

html_data %>%
  html_nodes("h2") %>%
  html_text()

# Classes

html_data %>%
  html_nodes(".cities_in_europe") %>%
  html_text()

html_data %>%
  html_nodes(".cities_in_asia") %>%
  html_text()

# Ids

html_data %>%
  html_node("#france") %>%
  html_text()

html_data %>%
  html_nodes("#france, #japan") %>%
  html_text()




