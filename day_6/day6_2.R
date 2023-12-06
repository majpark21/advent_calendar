library(stringr)
library(data.table)

# in_fi <- "./day_6/example6.txt"
in_fi <- "./day_6/input_6.txt"

times <- readLines(in_fi, warn = F)[1]
dists <- readLines(in_fi, warn = F)[2]
time_race <- as.numeric(str_replace_all(times, "(^Time:)|(\\s+)", ""), "\\s+")
dist_race <- as.numeric(str_replace_all(dists, "(^Distance:)|(\\s+)", ""), "\\s+")

# Difference between ran distance and winning distance, absolute to identify the points where the difference is 0 and not negative (shortest/longest possible winning times)
get_absDiffDist <- function(time_hold, time_race){
  dist_run <- time_hold * (time_race-time_hold)  # speed * time
  diff_dist <- abs(dist_race - dist_run)
  return(diff_dist)
}

# Optimize to find boundaries where the run time is equal to winning time
lo_time <- optimize(
  f=get_absDiffDist,
  interval=c(0, time_race),
  time_race=time_race,
  tol=0.01
)
lo_time <- ceiling(lo_time$minimum)

hi_time <- optimize(
  f=get_absDiffDist,
  interval=c(lo_time + 1, time_race),
  time_race=time_race,
  tol=0.01
)
hi_time <- floor(hi_time$minimum)

out <- hi_time - lo_time + 1
cat(out)
