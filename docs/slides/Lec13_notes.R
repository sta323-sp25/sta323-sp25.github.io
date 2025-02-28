library(tidyverse)

## Demo 1 ------------

# https://api.github.com/users/USER

jsonlite::read_json("https://api.github.com/users/rundel")


# https://api.github.com/orgs/ORG/repos

z = jsonlite::read_json("https://api.github.com/orgs/sta323-sp25/repos")

z = jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos")

z = jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos?per_page=100")

z |> map_chr("full_name")


# https://api.github.com/user - Get authenticated user

jsonlite::read_json("https://api.github.com/user")



## GitHub + httr2 example -----

library(httr2)

### User info ------

request("https://api.github.com/users/rundel") |>
  req_perform() |>
  resp_body_json()

last_response() |>
  resp_status()

last_response() |>
  resp_status_desc()



### Auth User info ------

request("https://api.github.com/user") |>
  req_perform() |>
  resp_body_json()

last_response() |>
  resp_status()

last_response() |>
  resp_status_desc()


gitcreds::gitcreds_set()

request("https://api.github.com/user") |>
  req_auth_bearer_token(gitcreds::gitcreds_get()$password) |> 
  #req_dry_run() |>
  req_perform() |> 
  resp_body_json()


request("https://api.github.com/user") |>
  req_headers(
    Authorization = paste("Bearer", gitcreds::gitcreds_get()$password)
  ) |>
  req_perform() |>
  resp_body_json()


### Org repos ------

request("https://api.github.com/orgs/sta323-sp25/repos") |>
  req_url_query(per_page = 100) |>
  req_perform() |>
  resp_body_json() |>
  map_chr("full_name")

request("https://api.github.com/orgs/sta323-sp25/repos") |>
  req_auth_bearer_token(gitcreds::gitcreds_get()$password) |>
  #req_url_query(per_page = 100) |>
  req_url_query(page = 2) |>
  req_perform() |>
  resp_body_json() |> 
  map_chr("full_name")

last_response() |> 
  resp_headers("link")


### Create a gist ----

# https://docs.github.com/en/rest/gists/gists?apiVersion=2022-11-28#create-a-gist

gist = request("https://api.github.com/gists") |>
  req_auth_bearer_token(gitcreds::gitcreds_get()$password) |>
  req_body_json( list(
    description = "Testing 1 2 3 ...",
    files = list("test.R" = list(content = "print('hello world')\n")),
    public = TRUE
  ) ) |>
  req_perform()

resp_body_json(gist)

resp_body_json(gist)$html_url
