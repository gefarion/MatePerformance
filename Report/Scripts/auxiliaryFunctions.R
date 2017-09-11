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

summarizeNotNormalizedData <- function(dataset){
  stats <- ddply(dataset, ~ Benchmark + VM + Suite,
                 summarise,
                 Time.mean                 = mean(Value),
                 Time.geomean              = geometric.mean(Value),
                 Time.stddev               = sd(Value),
                 Time.median               = median(Value),
                 max = max(Value),
                 min = min(Value))
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

selectWarmedupData <- function(data, numberOfIterations) {
  resultSet <- data
  for (vm in unique(data$VM)){
    warmups <- read.csv(paste("../Warmups/", warmupFilename(vm), sep=""), sep="\t", header = FALSE, skip=4)
    for (b in unique(data$Benchmark)) {
      row <- warmups[warmups$V1 == b,]
      if (nrow(row) == 0) {
        resultSet <- droplevels(subset(resultSet, Benchmark != b))
      } else {
        realValues <- suppressWarnings(as.numeric(row))
        realValues <- realValues[!is.na(row)]
        realValues <- realValues[realValues != '']
        warmup <- tail(realValues, n=1)
        if (!is.na(warmup)){
          resultSet <- droplevels(subset(resultSet,(
            (Benchmark != b) | (VM != vm) |
              (Benchmark == b & VM == vm & Iteration >= warmup + 3 & Iteration < warmup + numberOfIterations))))  
        } else {
          #No automatic warmup. Look for a manual one.
          warmups <- read.csv(paste("../Warmups/", "changePoint-manual.tsv", sep=""), sep="\t", header = FALSE, skip=2)
          row <- warmups[warmups$V1 == vm & warmups$V2 == b,]
          if (nrow(row) == 0) {
            print (paste(paste("Missing manual warmup value for", vm), b))  
          } else {
            warmup <- suppressWarnings(tail(as.numeric(row), n=1))
            resultSet <- droplevels(subset(resultSet,(
              (Benchmark != b) | (VM != vm) |
                (Benchmark == b & (VM == vm) & Iteration >= warmup + 3 & Iteration < warmup + numberOfIterations))))  
          }  
        }
      }
    }
  }
  return (resultSet)
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
    theme(axis.text.x = element_text(angle= 90, vjust=0.5, hjust=1), 
          legend.position="none", 
          plot.title = element_text(hjust = 0.5)) +
    #scale_y_log10(breaks=c(1,2,3,10,20,30,50,100,200,300,500,1000)) + #limit=c(0,30), breaks=seq(0,100,5), expand = c(0,0)
    #ggtitle("Runtime Factor, normalized to Java (lower is better)") + xlab("") +
    scale_fill_manual(values = col_values)
  if (!missing(yLimits)){
    plot <- plot + coord_flip(ylim = yLimits)
  } else {
    plot <- plot + coord_flip()	
  }
  
  plot
}

#Returns the first segment of at least size elements and which mean is not more than 
#thresholdRatio de minimun value of the dataset
segmentWithLengthAndMean <- function(ts, changepoints, size, iterations, thresholdRatio) {
  if (length(changepoints) == 0){
    #No changepoint
    return("No Warmup because there are no changepoints")
  }
  cps <- c(changepoints, iterations)
  segmentLengths <- diff(cps)
  segments <- which(segmentLengths > size)
  #only one changepoint > size?
  if (length(segments) == 0) {
      return("Warmup too late")
  } else {
    #Several changepoints > size
    threshold <- min(ts) * thresholdRatio
    for (i in 1:length(segments)){
      #Select the first which mean is related with the min of the timeseries
      bestFit <- c(1000000, 100000)
      startSegment <- cps[segments[i]]
      elements <- ts[(startSegment + 3):(startSegment + size - 2)]
      if (mean(elements) <= threshold){
        return(startSegment)
      } else {
        if (threshold - mean(elements) < bestFit[1]){
          bestFit[1] <- threshold - mean(elements)
          bestFit[2] <- startSegment
        }
      }
    }
    return(paste(paste(paste("No Warmup, best fit with mean difference", bestFit[1]), "at iteration"), bestFit[2])) 
  }
}

warmupFilename <- function(vm) {
  return (paste(paste("changePoint-",vm, sep=""),".tsv", sep=""))
}
  