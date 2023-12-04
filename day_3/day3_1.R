library(data.table)
library(stringr)

fi_in <- "./day_3/input_3_1.txt"
dt <- fread(fi_in, sep = "\\.", header = F)
