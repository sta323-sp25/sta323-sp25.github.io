library(rvest)
library(tidyverse)

## Example
url = "http://www.rottentomatoes.com/"

(session = polite::bow(url))

page = polite::scrape(session)


movies = tibble::tibble(
  title = page |> 
    html_elements(".dynamic-text-list__streaming-links+ ul .dynamic-text-list__item-title") |>
    html_text2(),
  tomatometer = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul rt-text") |>
    html_text2() |>
    str_remove("%$") |>
    as.numeric() |>
    (\(x) x/100)(),
  certified = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul score-icon-critics") |>
    html_attr("certified") |>
    str_to_upper() |>
    as.logical(),
  sentiment = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul score-icon-critics") |>
    html_attr("sentiment"),
  status = case_when(
     certified & sentiment == "positive" ~ "certified fresh",
    !certified & sentiment == "positive" ~ "fresh",
     sentiment == "negative" ~ "rotten"
  ),
  url = page |> 
    html_elements(".dynamic-text-list__streaming-links+ ul li a.dynamic-text-list__tomatometer-group") |>
    html_attr("href") |>
    (\(x) paste0(url, x))()
)


## Exercise 1

scrape_movie_page = function(url) {
  
  message("Scraping ", url)  
  
  page = polite::nod(session, url) |>
    polite::scrape()
  
  list(
    mpaa_rating = page |>
      html_elements(".unset+ rt-text") |>
      html_text2(),
    
    runtime = page |>
      html_elements("#hero-wrap rt-text:nth-child(4)") |>
      html_text2(),
    
    audience_score = page |>
      html_elements("rt-button:nth-child(7) rt-text") |> 
      html_text2() |>
      str_remove("%$") |>
      as.integer(),

    n_reviews = page |>
      html_elements('.critics-score-type+ rt-link') |>
      html_text2() |>
      str_remove(" Reviews"),
    
    n_aud_ratings = page |>
      html_elements('.audience-score-type+ rt-link') |>
      html_text2() |>
      str_remove(" Ratings")
  )
}

movies = movies |>
  mutate(
    details = purrr::map(url, scrape_movie_page)
  ) |>
  unnest_wider(details)




