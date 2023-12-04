library(data.table)
library(stringr)

fi_in <- "./day_4/input4_1.txt"
# fi_in <- "./day_4/example4_1.txt"
dt <- fread(fi_in, header = F, sep=NULL)
dt <- dt[V1 != ""]

dt[, game := str_extract(V1, "^Card +\\d+:")]
dt[, winning := str_replace(str_extract(V1, ":[ \\d]+"), ":", "")]
dt[, numbers := str_extract(V1, "[ \\d]+$")]

getScore <- function(str_win, str_smpl){
  # Convert strings to vectors of numbers
  str_win <- unlist(str_split(str_win, "\\s", simplify = F))
  str_win <- setdiff(str_win, "")
  str_smpl <- unlist(str_split(str_smpl, "\\s", simplify = F))
  str_smpl <- setdiff(str_smpl, "")
  
  n_win <- sum(str_smpl %in% str_win)
  score <- ifelse(n_win==0, 0, 2**(n_win-1))
  return(score)
}

dt[, score := getScore(winning, numbers), by=game]

out <- dt[, sum(score)]
cat(out)
