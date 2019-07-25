theme_mate <- function(font_size = 12, title_size = 14, facet_size=12) {
    theme_bw() +
    theme(
      legend.position="none", 
      plot.title = element_text(size = title_size, family = "Tahoma", face = "bold", hjust = 0.5),
      text=element_text(family = "Tahoma"),
      axis.text.x = element_text(colour="black", size = font_size, lineheight=0.7),
      axis.title = element_text(face="bold"),
      axis.text.y          = element_text(size = font_size),
      legend.text          = element_text(size = font_size),
      plot.margin = unit(c(0,0,0,0), "cm"),
      strip.text.x = element_text(size = facet_size, color = "black")
    ) 
}

basicPlot <- function(data, xCol, yCol, yTitle, xTitle, title, extraStuff, yLimits, xLabelVertical = FALSE, horizontal = FALSE) {
  if (missing(yTitle)) {
    yTitle = ""
  }
  
  if (missing(xTitle)) {
    xTitle = ""
  }
  
  if (missing(title)) {
    xTitle = ""
  }
  
  if (missing(yLimits)) {
    yLimits = c(min(data[[yCol]]), max(data[[yCol]]))
  }
  
  p <- ggplot(data, aes_string(x = xCol, y = yCol))  
  
  if (xLabelVertical) 
    p <- p + theme (axis.text.x = element_text(angle = 90, hjust = 1, vjust=0.5))
  
  if (yTitle == "")
    p <- p + theme (axis.text.y = element_blank())
  
  if (xTitle == "")
    p <- p + theme (axis.text.x = element_blank())
  
  if (!missing(title)) 
    p <- p + ggtitle(title)	
  
  if (!missing(extraStuff))
    p <- extraStuff(p)
  
  if (horizontal) {
    plot <- plot + coord_flip()
  }
  
  p
}

boxplot <- function (data, xCol, yCol, yTitle, xTitle, title, extraStuff, yLimits, xLabelVertical = FALSE, horizontal = FALSE) {
  p <- basicPlot(data, xCol, yCol, yTitle, xTitle, title, extraStuff, yLimits, xLabelVertical, horizontal)
  p +
    scale_y_continuous(name = yTitle) + 
    scale_x_discrete(name = xTitle) +
    theme_mate() +
    theme(panel.border = element_rect(colour = "black", fill = NA),
          plot.margin=unit(x=c(0.4,0,0,0),units="mm"))
}

lineplot <- function (data, xCol, yCol, yTitle, xTitle, title, extraStuff, yLimits, color, xLabelVertical = FALSE, horizontal = FALSE) {
  p <- basicPlot(data, xCol, yCol, yTitle, xTitle, title, extraStuff, yLimits, xLabelVertical = xLabelVertical, horizontal = horizontal)
  if (!missing(color))
    p <- p + geom_line(aes_string(colour = color))
  p +
    theme_mate() +
    #theme(legend.position = "none", axis.title.y=element_blank(),
    #      plot.title = element_text(size = titleSize, hjust = 0.5),
    #      plot.margin = unit(c(0.1,0.1,0.1,0.1), "lines")) + 
    scale_y_continuous() + 
    scale_x_continuous()
}

boxplotOverview <- function(stats, yLimits, yTitle, xTitle, title) {
  stats$VM <- reorder(stats$VM, X=stats$OF)
  vm_colors <- brewer.pal(length(vmNames), "Set3")
  # to replace scale_fill_brewer(type = "qual", palette = "Paired")
  names(vm_colors) <- vmNames

  colorify <- function(plot) {
    plot + 
      geom_hline(yintercept = 1, linetype = "dashed") + 
      geom_boxplot(outlier.size = 0.5, alpha = 0.8, aes(fill=VM)) + 
      stat_summary(fun.y=mean, geom="point", shape=20, size=4, color="black") +
      scale_fill_manual(values = vm_colors) + 
      geom_jitter()
  }
  
  #stats$VM <- revalue(stats$VM, c("SOMpe" = expression(SOM[pe]), "SOMmt" = expression(SOM[mt])))
  
  boxplot(stats, "VM", "OF", yTitle, xTitle, title, colorify, yLimits)
}

basicPlottingDecorator <- function(plot) {
  plot + 
    geom_hline(yintercept = 1, linetype = "dashed") + 
    geom_boxplot(outlier.size = 0.9)
}

addFacetDecorator <- function(plot) {
  basicPlottingDecorator(plot) + 
    facet_grid(VM~., labeller = label_parsed)
}

boxplotMateToSom <- function(data, baselineNames, yTitle, xTitle, title) {
  normalizedOverall <- data.frame(matrix(NA, nrow = 0, ncol = length(data[[1]])))
  colnames(normalizedOverall) <- colnames(data[[1]])
  for (i in 1:length(data)) {
    if (length(baselineNames) == length(data)){
      normalized <- normalizeData(data[[i]], ~ Benchmark, baselineNames[[i]], FALSE)
    } else {
      normalized <- data[[i]]
    }
    normalizedOverall <- rbind(normalizedOverall, normalized)
  }
  
  normalizedOverall$VM <- revalue(normalizedOverall$VM, c("MATEpe" = expression(Mate[pe]), "MATEmt" = expression(Mate[mt])))
  
  boxplot(normalizedOverall, "Benchmark", "RuntimeRatio", yTitle, xTitle, title, addFacetDecorator, xLabelVertical = TRUE)
}

boxplotMateToSomNormalized <- function(data, yTitle, xTitle, title) {
  boxplot(data, "Benchmark", "RuntimeRatio", yTitle, xTitle, title, addFacetDecorator)
}

warmupPlot <- function (data, yTitle, xTitle, title, summaries, group = "VM") {
  warmupDecorator <- function(plot) {
    plot + 
      scale_color_manual(values=c("MATEpe"="blue", "MATEmt"="green")) +
      facet_wrap(Benchmark~., labeller = label_parsed)
  }
  
  p <- lineplot(data, yTitle, xTitle, title, extraStuff = warmupDecorator, color = group) 

  if (!missing(summaries)){
    #todo: Distinguish color for each hline + add ribbons
    p <- p + geom_hline(data=summaries, aes_string(yintercept = "OF"), linetype="dashed", alpha=0.4)
    #p <- p + geom_hline(data=summaries, aes(yintercept = OF), linetype="dashed", alpha=0.4, color = "blue")
    #p <- p + geom_ribbon(data = data.frame(x=c(1:100)), aes(x = 1:100, ymin = rep(hLines[[1]][2], 100), 
    #                                                        ymax = rep(hLines[[1]][3], 100)), fill = "blue", alpha = 0.2)
    #p <- p + geom_hline(aes(yintercept = hLines[[2]][1]), linetype="dashed", alpha=0.4, color = "green")
    #p <- p + geom_ribbon(data = data.frame(x=c(1:100)), aes(x = 1:100, ymin = rep(hLines[[2]][2], 100), 
    #                                                        ymax = rep(hLines[[2]][3], 100)), fill = "green", alpha = 0.2)
  }
  return(p)
}