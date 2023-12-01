library(stringr)
library(data.table)

fi_in <- "./day_1/input_1.txt"
dt <- fread(fi_in, header = F)
dt <- dt[V1 != ""]

regex_first <- "^.*?(\\d{1})"  # Map 1st digit
regex_second <- "(\\d{1})(?!.*\\d)"  # Map last digit

dt[, first := str_extract(V1, regex_first, group=1)]
dt[, second := str_extract(V1, regex_second, group=1)]
dt[, third := as.numeric(paste0(first, second))]

out <- dt[, sum(third)]
cat(out)
