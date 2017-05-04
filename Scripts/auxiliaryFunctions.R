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
                   OverallRtFactor = geometric.mean(RuntimeFactor),
                   sd              = sd(RuntimeFactor),
                   min             = min(RuntimeFactor),
                   max             = max(RuntimeFactor),
                   median          = median(RuntimeFactor))
  overall
}

normalizeData <- function (dataset, normalizeTo, keepBaseline) {
  # normalize for each benchmark separately to the baseline
  norm <- ddply(dataset, ~ Benchmark, transform,
                RuntimeRatio = Value / mean(Value[VM == "TruffleSOM"]))
  
  if (!keepBaseline){
    norm <- droplevels(subset(norm, VM != normalizeTo))  
  }
  
  norm
}

summarizeMopOperations <- function (data, discriminator){
  ### Individual MOP operations
  stats <- summarizeData(data)
  
  #allOperations <- ddply(stats, ~ Benchmark , transform, 
  #                       Var = grepl("VMReflective", Benchmark),
  #                       Benchmark = gsub("VMReflective", "", Benchmark))
  
  #allOperations$Benchmark <- factor(allOperations$Benchmark)
  
  #standardOperations <- droplevels(subset(allOperations, Var == FALSE))
  
  name_map <- list(
    "FieldRead"		= "LayoutFieldRead",
    "FieldWrite"	= "LayoutFieldWrite",
    "MessageSend"	= "MethodActivation"
  )
  
  #levels(standardOperations$Benchmark) <- map_names(
  #  levels(standardOperations$Benchmark),
  #  name_map)
  
  #allOperations <- rbind(allOperations, standardOperations)
  
  #allOperationsNormalized <- ddply(allOperations, ~ Benchmark + VM, transform,
  #                                 RuntimeRatio = Time.mean / Time.mean[Var == FALSE])
  
  name_map <- list(
    "LayoutFieldRead"		= "Read",
    "LayoutFieldWrite"		= "Write",
    "MessageSend"			= "Send",
    "MethodActivation" 		= "Activation",
    "AllOperations" 		= "All",
    "SeveralObjectsFieldRead" 	= "Mega2",
    "SeveralObjectsFieldReadOneMO" 	= "Mono2",
    "SeveralObjectsFieldRead2" 	= "Mega",
    "SeveralObjectsFieldReadOneMO2" = "Mono"
  )
  
  #levels(allOperationsNormalized$Benchmark) <- map_names(
  #  levels(allOperationsNormalized$Benchmark),
  #  name_map)
  
  stats
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
  #  p <- p + facet_grid(~VM, labeller = label_parsed)
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
  #p <- p + coord_cartesian(ylim = c(scaleyLow, scaleyHigh))	
  #p <- p + ggtitle(titleHorizontal)	
  p
}  
