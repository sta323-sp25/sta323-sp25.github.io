library(tidyverse)

## Exercise 1

x = c("Jeremy Cruz", "Nathaniel Le", "Jasmine Chu", "Bradley Calderon Raygoza", 
      "Quinten Weller", "Katelien Kanamu-Hauanio", "Zuhriyaa al-Amen", 
      "Travale York", "Alexis Ahmed", "David Alcocer", "Jairo Martinez", 
      "Dwone Gallegos", "Amanda Sherwood", "Hadiyya el-Eid", "Shaimaaa al-Can", 
      "Sarah Love", "Shelby Villano", "Sundus al-Hashmi", "Dyani Loving", 
      "Shanelle Douglas")

### detects if the person’s first name starts with a vowel (a,e,i,o,u)

str_subset(x, "^[AEIOU]")

str_subset(tolower(x), "^[aeiou]")

str_subset(x, regex("^[aeiou]", ignore_case = TRUE))


### detects if the person’s last name starts with a vowel

str_subset(x, " [AEIOUaeiou]")

# str_subset(x, "\\b[AEIOUaeiou]") # incorrect

### detects if either the person’s first or last name start with a vowel

str_subset(x, "^[AEIOU]| [AEIOUaeiou]")

str_subset(x, "\\b[AEIOUaeiou]")

### detects if neither the person’s first nor last name start with a vowel

!str_detect(x, "^[AEIOU]") &  !str_detect(x, "[AEIOUaeiou]")

str_subset(x, "^[^AEIOU]\\w* [^AEIOUaeiou]")



## Exercise 2

text = c(
  "apple" , 
  "219 733 8965" , 
  "329-293-8753" ,
  "Work: (579) 499-7527; Home: (543) 355 3679"
)

str_match_all(
  text, "\\(?(\\d{3})\\)?[- ](\\d{3})[- ](\\d{4})"
)














