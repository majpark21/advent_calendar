library(data.table)
library(stringr)

fi_in <- "./day_4/input4_1.txt"
# fi_in <- "./day_4/example4_1.txt"
dt <- fread(fi_in, header = F, sep=NULL)
dt <- dt[V1 != ""]

dt[, game := str_extract(V1, "^Card +(\\d+):", group=1)]
dt[, winning := str_replace(str_extract(V1, ":[ \\d]+"), ":", "")]
dt[, numbers := str_extract(V1, "[ \\d]+$")]

getScore <- function(str_win, str_smpl){
  # Convert strings to vectors of numbers
  str_win <- unlist(str_split(str_win, "\\s", simplify = F))
  str_win <- setdiff(str_win, "")
  str_smpl <- unlist(str_split(str_smpl, "\\s", simplify = F))
  str_smpl <- setdiff(str_smpl, "")
  
  n_win <- sum(str_smpl %in% str_win)
  return(n_win)
}

dt[, score := getScore(winning, numbers), by=game]

dt_Ncopies <- dt[, .(game, score)]
dt_Ncopies[, Ncopy := 1]
for(ii in 1:nrow(dt_Ncopies)){
  curr_game <- dt_Ncopies[ii, game]
  curr_score <- dt_Ncopies[ii, score]
  curr_copy <- dt_Ncopies[ii, Ncopy]
  if(curr_score > 0){
    dt_Ncopies[(ii+1):(ii+curr_score), Ncopy := Ncopy + curr_copy]
  }
}

out <- dt_Ncopies[, sum(Ncopy)]
cat(out)
