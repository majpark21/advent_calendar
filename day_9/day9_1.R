library(stringr)
# in_fi <- "day_9/example9.txt"
in_fi <- "day_9/input_9_1.txt"

inputs <- readLines(in_fi)
inputs <- lapply(inputs, function(x){as.numeric(unlist(str_split(x, " ")))})

last <- function(x){return(x[length(x)])}

getDiffs <- function(x, out=list()){
  # Add initial vector
  if(length(out)==0){
    out[[1]] <- x
  }
  if(all(x==0)){
    return(out)
  } else {
    diffs <- diff(x)
    out[[length(out) + 1]] <- diffs
    getDiffs(diffs, out)
  }
}

predictLast <- function(l_diffs, curr_lvl=length(l_diffs)){
  last_lvl <- length(l_diffs)
  if(curr_lvl==0){
    # Last of first lvl
    return(l_diffs[[1]][length(l_diffs[[1]])])
  } else if(curr_lvl==last_lvl) {
    new_val <- 0
  } else {
    # Last from current level + last from level below
    new_val <- l_diffs[[curr_lvl]][length(l_diffs[[curr_lvl]])] + l_diffs[[curr_lvl+1]][length(l_diffs[[curr_lvl+1]])]
  }
  l_diffs[[curr_lvl]][length(l_diffs[[curr_lvl]])+1] <- new_val
  predictLast(l_diffs, curr_lvl = curr_lvl-1)
}


l_diffs <- lapply(inputs, getDiffs)
l_preds <- lapply(l_diffs, predictLast)
out <- sum(unlist(l_preds))
cat(out)
