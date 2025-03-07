library(tidyverse)
library(httr2)


## Example 1


# Demo the following by hand with browser
# /echo
# /plot
# /sum
# /msg/<from>/<to>
# /user/<id>

request("http://127.0.0.1:6977/echo") |>
  req_url_query(msg = "hello") |>
  req_perform() |>
  resp_body_json()


request("http://127.0.0.1:6977/user/") |>
  req_url_path_append("1234") |>
  req_url_path_append("TRUE") |>
  req_method("POST") |> 
  req_perform() |>
  resp_body_json()
