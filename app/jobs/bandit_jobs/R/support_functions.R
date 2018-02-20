library(ggplot2)
library(data.table)
library(clue)
library(cluster)
library(randomForest)
library(rcompanion)
library(MASS)
library(dbscan)

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

tree_func <- function(final_model, tree_num) {
  require(dplyr)
  require(ggraph)
  require(igraph) 
  
  # get tree by index
  tree <- randomForest::getTree(final_model, 
                                k = tree_num, 
                                labelVar = TRUE) %>%
    tibble::rownames_to_column() %>%
    # make leaf split points to NA, so the 0s won't get plotted
    mutate(`split point` = ifelse(is.na(prediction), `split point`, NA))
  
  # prepare data frame for graph
  graph_frame <- data.frame(from = rep(tree$rowname, 2),
                            to = c(tree$`left daughter`, tree$`right daughter`))
  
  # convert to graph and delete the last node that we don't want to plot
  graph <- graph_from_data_frame(graph_frame) %>%
    delete_vertices("0")
  
  # set node labels
  V(graph)$node_label <- gsub("_", " ", as.character(tree$`split var`))
  V(graph)$leaf_label <- as.character(tree$prediction)
  V(graph)$split <- as.character(round(tree$`split point`, digits = 2))
  
  # plot
  plot <- ggraph(graph, 'dendrogram') + 
    theme_bw() +
    geom_edge_link() +
    geom_node_point() +
    geom_node_text(aes(label = node_label), na.rm = TRUE, repel = TRUE) +
    geom_node_label(aes(label = split), vjust = 2.5, na.rm = TRUE, fill = "white") +
    geom_node_label(aes(label = leaf_label, fill = leaf_label), na.rm = TRUE, 
                    repel = TRUE, colour = "white", fontface = "bold", show.legend = FALSE) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.background = element_blank(),
          plot.background = element_rect(fill = "white"),
          panel.border = element_blank(),
          axis.line = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          plot.title = element_text(size = 18))
  
  print(plot)
}

fviz_silhouette <- function(sil.obj, label = FALSE, print.summary = TRUE, ...){
  
  if(inherits(sil.obj, c("eclust", "hcut", "pam", "clara", "fanny"))){
    df <- as.data.frame(sil.obj$silinfo$widths)
  }
  else if(inherits(sil.obj, "silhouette"))
    df <- as.data.frame(sil.obj[, 1:3])
  else stop("Don't support an oject of class ", class(sil.obj))
  
  # order by cluster and by sil_width
  df <- df[order(df$cluster, -df$sil_width), ]
  if(!is.null(rownames(df))) df$name <- factor(rownames(df), levels = rownames(df))
  else df$name <- as.factor(1:nrow(df))
  df$cluster <- as.factor(df$cluster)
  mapping <- aes_string(x = "name", y = "sil_width", 
                        color = "cluster", fill = "cluster")
  p <- ggplot(df, mapping) +
    geom_bar(stat = "identity") +
    labs(y = "Silhouette koeficient Si", x = "",
         title = paste0("Silhouette graf",
                        "\nPriemerná hodnota koeficientu: ", 
                        round(mean(df$sil_width), 2)))+
    ggplot2::ylim(c(NA, 1))+
    geom_hline(yintercept = mean(df$sil_width), linetype = "dashed", color = "red" )
  p <- ggpubr::ggpar(p, ...)
  # Labels
  if(!label) p <- p + theme(axis.text.x = element_blank(), 
                            axis.ticks.x = element_blank())
  else if(label)
    p <- p + theme(axis.text.x = element_text(angle=45))
  
  # Print summary
  ave <- tapply(df$sil_width, df$cluster, mean)
  n <- tapply(df$cluster, df$cluster, length)
  sil.sum <- data.frame(cluster = names(ave), size = n,
                        ave.sil.width = round(ave,2))
  if(print.summary) print(sil.sum)
  
  p
}

createCorrplot <- function(data) {
  library(corrplot)
  col4 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","#7FFF7F", "cyan", "#007FFF", "blue","#00007F"))

  #png(height=1200, width=1500, pointsize=15, file="overlapp.png")
  
  corrplot(cor(data, use="complete"), method=c("number"), bg = "grey10",
           addgrid.col = "gray50", tl.cex=1,
           tl.col = "black", 
           col = colorRampPalette(c("yellow","green","navyblue"))(100))
  
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

# setwd('~/School/DiplomaProject/StructureRecommendation/')
# users_csv <- getCsv('./Data/data_so_eng.csv')

