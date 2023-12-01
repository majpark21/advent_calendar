library(stringr)
library(data.table)

fi_in <- "./day_1/input_2.txt"
dt <- fread(fi_in, header = F)
dt <- dt[V1 != ""]

digits <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")

# Extract first
regex_first <- paste0("(", paste(digits, collapse = ")|("), ")")
regex_first <- paste0("^.*?(", regex_first, "|(\\d{1}))")
dt[, first := str_extract(V1, regex_first, group=1)]


# Extract second: Reverse strings and look for reversed patterns at the beginning of string
regex_second <- strsplit((paste0(")", paste(digits, collapse = "(|)"), "(")), NULL)[[1]]
regex_second <- paste(rev(regex_second), collapse = "")
regex_second <- paste0("^.*?(", regex_second, "|(\\d{1}))")
dt[, second := str_extract(stringi::stri_reverse(V1), regex_second, group=1)]
dt[, second := stringi::stri_reverse(second)]


# Translate literal strings into corresponding digits
dt[, first := dplyr::case_match(
  first,
  "one" ~ "1",
  "two" ~ "2",
  "three" ~ "3",
  "four" ~ "4",
  "five" ~ "5",
  "six" ~ "6",
  "seven" ~ "7",
  "eight" ~ "8",
  "nine" ~ "9",
  .default = first
)]

dt[, second := dplyr::case_match(
  second,
  "one" ~ "1",
  "two" ~ "2",
  "three" ~ "3",
  "four" ~ "4",
  "five" ~ "5",
  "six" ~ "6",
  "seven" ~ "7",
  "eight" ~ "8",
  "nine" ~ "9",
  .default = second
)]


dt[, third := as.numeric(paste0(first, second))]
out <- dt[, sum(third)]
cat(out)
