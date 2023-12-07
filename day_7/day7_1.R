library(data.table)
library(stringr)

# in_fi <- "./day_7/example_7.txt"
in_fi <- "./day_7/input_7_1.txt"

dt <- fread(in_fi, header=F)
setnames(dt, c("hand", "bid"))
dt[, idx_hand := 1:nrow(dt)]

# Sort hands strings
sortString <- function(x){
  paste(sort(unlist(strsplit(x, ""))), collapse = "")
}
# Running length encoding to detect nber of quadruple, triple and double
getNCombi <- function(x_sorted, n=2){
  encod <- rle(unlist(strsplit(x_sorted, ""))) # 2 = pairs, 3 = triples...
  out <- sum(encod$lengths==n)
  return(out)
}
# Translate into ranked hand type
getType <- function(n_pair, n_triple, n_carre, n_penta){
  if(n_penta==1){
    return(7)
  } else if (n_carre==1){
    return(6)
  } else if ((n_triple==1) & (n_pair==1)){
    return(5)
  } else if ((n_triple==1) & (n_pair==0)){
    return(4)
  } else if (n_pair==2){
    return(3)
  } else if ((n_pair==1) & (n_triple==0)){
    return(2)
  } else {
    return(1)
  }
}
# For all hands of same type, order them according to order of appearance of cards
isLarger <- function(hand1, hand2){
  order_cards <- 1:13
  names(order_cards) <- c(as.character(2:9), "T", "J", "Q", "K", "A")
  v_1 <- order_cards[unlist(strsplit(hand1, ""))]
  v_2 <- order_cards[unlist(strsplit(hand2, ""))]
  comp1 <- v_1 > v_2
  comp2 <- v_1 < v_2
  # Equal hands
  if(all(!comp1) & all(!comp2)){
    return(FALSE)
  }
  if(all(comp1)){
    return(TRUE)
  }
  if(all(comp2)){
    return(FALSE)
  }
  if(all(!comp1)){
    return(FALSE)
  }
  if(all(!comp2)){
    return(TRUE)
  }
  first1 <- which(comp1)[1]
  first2 <- which(comp2)[1]
  if(first1 < first2){
    return(TRUE)
  } else {
    return(FALSE)
  }
}

bubbleSort <- function(arr){
  n = length(arr)
  if(n == 1){
    return(arr)
  }
  # Traverse through all array elements
  for(i in 1:n){
    swapped = F
    # Last i elements are already in place
    for(j in 1:(n-i)){
      # Traverse the array from 0 to n-i-1
      # Swap if the element found is greater
      # than the next element
      if(isLarger(arr[j], arr[j+1])){
      # if(arr[j] > arr[j+1]){
        tmp <- arr[j]
        arr[j]  = arr[j+1]
        arr[j+1] = tmp
        swapped = T
      }
    }
    if (swapped == F){
      break
    }
  }
  return(arr)
}

getRank <- function(arr){
  sorted <- bubbleSort(arr)
  ranks <- sapply(arr, function(x) which(sorted==x))
  return(ranks)
}

# Apply
dt[, s_hand := sortString(hand), by=idx_hand]
dt[, n_pair := getNCombi(s_hand, 2), , by=idx_hand]
dt[, n_triple := getNCombi(s_hand, 3), by=idx_hand]
dt[, n_carre := getNCombi(s_hand, 4), by=idx_hand]
dt[, n_penta := getNCombi(s_hand,5), by=idx_hand]
dt[, hand_type := getType(n_pair, n_triple, n_carre, n_penta), by=idx_hand]
dt[, rank_inType := getRank(hand), by=hand_type]
setorder(dt, hand_type, rank_inType)
dt[, rank_all := 1:nrow(dt)]

out <- sum(dt[, bid * rank_all])
cat(out)
