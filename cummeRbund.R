library(cummeRbund)

# one level up of cuffdiff dir
setwd('')

# read cuffdiff data
cuff_data <- readCufflinks(dir='cuffdiff/')

# gene & isoform expression plots
# example of Ttn gene
pdf(file="Ttn.pdf")
mygene = getGene(cuff_data,'Ttn')
expressionbarplot(mygene)
expressionbarplot(isoforms(mygene))
dev.off()

# change the function expressionbarplot
expressionbarplot <- function(object,logMode=FALSE,pseudocount=1.0,showErrorbars=TRUE,showStatus=TRUE,replicates=FALSE,...){
  quant_types <- c("OK","FAIL","LOWDATA","HIDATA","TOOSHORT")
  quant_types <- factor(quant_types, levels = quant_types)
  quant_colors <- c("black","red","blue","orange","green")
  names(quant_colors) <- quant_types
  
  dat <- fpkm(object)
  if(replicates){
    repDat <- repFpkm(object)
    colnames(repDat)[1] <- "tracking_id"
  }
  
  #TODO: Test dat to ensure that there are >0 rows to plot.  If not, trap error and move on...
  
  colnames(dat)[1] <- "tracking_id"
  
  if(logMode)
  {
    dat$fpkm <- dat$fpkm + pseudocount
    dat$conf_hi <- dat$conf_hi + pseudocount
    dat$conf_lo <- dat$conf_lo + pseudocount
    
    if(replicates){
      repDat$fpkm<-repDat$fpkm + pseudocount
    }
  }
  
  p <- ggplot(dat, aes(x = sample_name, y = fpkm, fill = sample_name))
  
  p <- p + geom_bar(stat = "identity")
  
  if(replicates){
    p <- p + geom_point(aes(x = sample_name, y = fpkm), size = 3, shape = 18, colour = "black", data = repDat)
  }
  
  if (showErrorbars)
  {
    p <- p +
      geom_errorbar(aes(ymin = conf_lo, ymax = conf_hi, group = 1), width = 0.5)
  }
  
  if (logMode)
  {
    p <- p + scale_y_log10()
  }
  
  p <- p + facet_wrap('tracking_id') +
    labs(title = object@annotation$gene_short_name) + theme(axis.text.x = element_text(hjust = 0, angle = -90))
  
  if (logMode)
  {
    p <- p + ylab(paste("FPKM +", pseudocount))
  } else {
    p <- p + ylab("FPKM")
  }
  
  if (showStatus){
    if(logMode){
      p <- p + geom_text(aes(x = sample_name, y = 1, label = quant_status, color = quant_status), vjust = 1.5, size = 3)
      
    }else{
      p <- p + geom_text(aes(x = sample_name, y = 0, label = quant_status, color = quant_status), vjust = 1.5, size = 3)
    }
  }
  
  p <- p + theme(legend.position = "none")
  
  #Default cummeRbund colorscheme
  p <- p + scale_fill_hue(l = 50, h.start = 200)
  
  #Recolor quant flags
  p <- p + scale_colour_manual(name = 'quant_status', values = quant_colors)
  
  p
}
