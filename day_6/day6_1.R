library(stringr)
library(data.table)

# in_fi <- "./day_6/example6.txt"
in_fi <- "./day_6/input_6.txt"

times <- readLines(in_fi, warn = F)[1]
dists <- readLines(in_fi, warn = F)[2]
times <- as.numeric(unlist(str_split(str_replace(times, "^Time:\\s+", ""), "\\s+")))
dists <- as.numeric(unlist(str_split(str_replace(dists, "^Distance:\\s+", ""), "\\s+")))

get_nberWinningHoldTimes <- function(time_race, dist_race){
  times_hold <- 0:time_race
  dists_run <- times_hold * (time_race-times_hold)
  n_winning <- sum(dists_run > dist_race)
  return(n_winning)
}

n_wins <- sapply(1:length(times), function(ii_race){get_nberWinningHoldTimes(times[ii_race], dists[ii_race])})
out <- prod(n_wins)
cat(out)
