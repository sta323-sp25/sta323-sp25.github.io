library(tidyverse)
library(rvest)

## Agenda
# - Show LQ structure
#   https://www.wyndhamhotels.com/laquinta/locations
#
# - Find the lat / long on a restaurant page
#
# - Show denny's structure
#   https://locations.dennys.com/
#

x = read_html("https://www.wyndhamhotels.com/laquinta/locations") |>
  html_nodes(".property a:nth-child(1)") |>
  html_attr("href")

# - Find the lat / long on a hotel page

page = read_html("https://www.wyndhamhotels.com/laquinta/durham-north-carolina/la-quinta-raleigh-durham-southpoint/overview")

html_nodes(page, "a.property-address-mobile")

# - Denny's API example

library(tidyverse)

url = paste0(
        "https://nomnom-prod-api.dennys.com/restaurants/near",
        "?lat=35.994&long=-78.8986&radius=20&limit=6",
        "&nomnom=calendars&nomnom_calendars_from=20211011&nomnom_calendars_to=20211019&nomnom_exclude_extref=999"
      )

z = jsonlite::read_json(
  url
)

api_url = function(lat, long, r=20, n=6) {
  glue::glue(
    "https://nomnom-prod-api.dennys.com/restaurants/near",
    "?lat={lat}&long={long}&radius={r}&limit={n}",
    "&nomnom=calendars&nomnom_calendars_from=20211011&nomnom_calendars_to=20211019&nomnom_exclude_extref=999"
  )
}

api_url(35.994,-78.898) %>%
  jsonlite::read_json() %>%
  str()

api_url(35.994,-78.898, r=1000, n=100) %>%
  jsonlite::read_json() %>%
  {tibble::tibble(data = .$restaurants)} %>%
  unnest_wider(data) %>% 
  View()


api_url(34.0635, -118.4455, r=100, n=100) %>%
  jsonlite::read_json() %>%
  {tibble::tibble(data = .$restaurants)} %>%
  unnest_wider(data) %>% View()
 
