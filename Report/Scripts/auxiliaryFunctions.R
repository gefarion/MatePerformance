summarizeData <- function(dataset){
  stats <- ddply(dataset, ~ Benchmark + VM,
                 summarise,
                 RuntimeFactor = geometric.mean(RuntimeRatio),
                 sd            = sd(Value),
                 median        = median(Value),
                 max           = max(Value),
                 min           = min(Value))
  stats
}

summarizeOverall <- function(dataset){
  overall <- ddply(dataset, ~ VM, summarise,
                   Geomean         = geometric.mean(RuntimeFactor),
                   Sd              = sd(RuntimeFactor),
                   Min             = min(RuntimeFactor),
                   Max             = max(RuntimeFactor),
                   Median          = median(RuntimeFactor))
  overall
}

normalizeData <- function (dataset, keepBaseline) {
  # normalize for each benchmark separately to the baseline
    norm <- ddply(dataset, ~ Benchmark, transform,
                  RuntimeRatio = Value / mean(Value[grepl("SOM", VM)]))
  if (!keepBaseline){
    norm <- droplevels(subset(norm, !grepl("SOM", VM)))  
  }
  
  norm
}

selectIterationsAndInlining <- function(data, filename, rowNames, numberOfIterations) {
  bench <- read.table(filename, sep="\t", header=FALSE, col.names=rowNames, fill=TRUE)
  resultSet <- data
  for (b in levels(data$Benchmark)) {
    row <- bench[bench$Benchmark == b,]
    if (is.null(row)) {
      resultSet <- droplevels(subset(resultSet, Benchmark != b))
    } else {
      resultSet <- droplevels(subset(resultSet,(
          (Benchmark != b) |
          (Benchmark == b & Iteration >= row$Iterations & Iteration < row$Iterations + numberOfIterations)  
        )
      ))
    }
  }
  resultSet
}

boxplot <- function (data, axisYText, titleVertical) {
  p <- ggplot(data, aes(x = Benchmark, y = RuntimeRatio))
  p <- p + facet_grid(~VM, labeller = label_parsed)
  p <- p + geom_hline(yintercept = 1, linetype = "dashed")
  p <- p + geom_boxplot(outlier.size = 0.9) + theme_simple()
  p <- p + scale_y_continuous(name=titleVertical) + 
    theme(panel.border = element_rect(colour = "black", fill = NA),
          plot.margin=unit(x=c(0.4,0,0,0),units="mm"),
          text = element_text(size = 8))
  if (axisYText){
  p <- p + theme (axis.text.x = element_text(angle = 90, hjust = 1, vjust=0.5))
  } else {
  p <- p + theme (axis.text.x = element_blank())
  }
  #p <- p + ggtitle(titleHorizontal)	
  p
}

overview_box_plot <- function(stats, yLimits) {
  stats$VM <- reorder(stats$VM, X=-stats$Geomean)
  
  breaks <- levels(droplevels(stats)$VM)
  col_values <- sapply(breaks, function(x) vm_colors[[x]])
  
  plot <- ggplot(stats, aes(x=VM, y=RuntimeFactor, fill = VM))
  
  plot <- plot +
    geom_boxplot(outlier.size = 0.5) + #fill=get_color(5, 7)
    theme_bw() + theme_simple(font_size = 12) +
    theme(axis.text.x = element_text(angle= 90, vjust=0.5, hjust=1), legend.position="none", plot.title = element_text(hjust = 0.5), aspect.ratio=0.5) +
    #scale_y_log10(breaks=c(1,2,3,10,20,30,50,100,200,300,500,1000)) + #limit=c(0,30), breaks=seq(0,100,5), expand = c(0,0)
    #+ coord_flip()
    #ggtitle("Runtime Factor, normalized to Java (lower is better)") + xlab("") +
    scale_fill_manual(values = col_values)
  if (!missing(yLimits)){
    plot <- plot + coord_cartesian(ylim = yLimits)	
  }
  plot
}
