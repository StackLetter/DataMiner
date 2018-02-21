library(data.table)
library(clue)
library(cluster)
library(MASS)

set.seed(1000)

getCsv <- function(name, encoding="UTF-8"){
  return (fread(name, encoding = encoding))
}

saveCsv <- function(data_table, path, encoding="UTF-8") {
  con<-file(path, encoding = encoding)
  fwrite(data_table, path)
  close(con)
}

z_min <- function(vector) {
	sd_v = sd(vector)
  min_v = min(vector)
        
  return ((vector - min_v) / sd_v)
}

z_mean <- function(vector) { # eq to scale function
	sd_v = sd(vector)
  mean_v = mean(vector)
        
  return((vector - mean_v) / sd_v)
}


min_max <- function(vector) {
  min_v = min(vector)
  max_v = max(vector)
  
  return((vector - min_v) / (max_v - min_v))
}

min_maxForStackLetterUsers <- function(train_vector,  min_max_vector) {
  min_v = min(train_vector)
  max_v = max(train_vector)
  
  return((min_max_vector - min_v) / (max_v - min_v))
}

boxCox <- function(data, attr) {
  Box = boxcox(data[, get(attr)] + abs(min(data[, get(attr)])) + 1 ~ 1, lambda = seq(-6,6,0.1), plotit = FALSE)

  Cox = data.frame(Box$x, Box$y)

  Cox2 = Cox[with(Cox, order(-Cox$Box.y)),]
  Cox2[1,]

  lambda = Cox2[1, "Box.x"]
  T_box = ((data[, get(attr)] + abs(min(data[, get(attr)])) + 1) ^ lambda - 1) / lambda

  return(T_box)
}

boxCoxForStacklettterUsers <- function(data, attr, users) {
  Box = boxcox(data[, get(attr)] + abs(min(data[, get(attr)])) + 1 ~ 1, lambda = seq(-6,6,0.1), plotit = FALSE)
  
  Cox = data.frame(Box$x, Box$y)
  
  Cox2 = Cox[with(Cox, order(-Cox$Box.y)),]
  Cox2[1,]
  
  lambda = Cox2[1, "Box.x"]
  T_box = ((users[, get(attr)] + abs(min(users[, get(attr)])) + 1) ^ lambda - 1) / lambda
  
  return(T_box)
}

