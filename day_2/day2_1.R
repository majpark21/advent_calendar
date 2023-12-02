library(data.table)
library(stringr)

fi_in <- "./day_2/input_2_1.txt"
n_red <- 12
n_green <- 13
n_blue <- 14

dt <- fread(fi_in, sep = NULL, header = F)

# dt <- data.table(V1=c("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
# "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
# "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
# "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
# "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
# ))

# Samples information is not useful, concatenate all samples into 1
l_game <- lapply(dt$V1, function(x){x <- str_replace(x, "^Game \\d+: ", ""); str_replace_all(x, ";", ",")})
names(l_game) <- str_extract(dt$V1, "^Game (\\d+):", group=1)

# Extract the max for each color in each game. If max > number cubes then impossible
getMaxColor <- function(l_string, color){
  tmp <- lapply(l_string, function(x){paste(unlist(str_extract_all(x, paste0("(\\d+) ", color))), collapse = ",")})
  tmp <- lapply(tmp, function(x){
    as.numeric(unlist(
      str_extract_all(x, "(\\d+)")
    ))})
  tmp <- lapply(tmp, max)
  return(tmp)
}

max_red <- getMaxColor(l_game, "red") 
outlier_red <- names(max_red)[max_red > n_red]
max_blue <- getMaxColor(l_game, "blue") 
outlier_blue <- names(max_blue)[max_blue > n_blue]
max_green <- getMaxColor(l_game, "green") 
outlier_green <- names(max_green)[max_green > n_green]


# Solution
impossible_games <- Reduce(union, list(outlier_red, outlier_green, outlier_blue))
possible_games <- setdiff(names(l_game), impossible_games)

out <- sum(as.numeric(possible_games))
cat(out)
