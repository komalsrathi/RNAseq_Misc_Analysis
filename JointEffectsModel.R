# This is a variation of Difftest function in JointEffectsModel.R in GTEx folder
# When you have normals and treated samples, you have to take into consideration of the effect of disease on gene expression
# Now, in this case my data has sample name, age, gender and treatment as variables
# that you can adjust according to the number of variables you have

DiffTest <- function(x,expr.sub)
{
  expr = paste("a=alldata[,list(sample_name,age,gender,treat,",as.character(x$Genes[1]),',',as.character(x$lnc[1]),")]",sep='')
  eval(parse(text=expr))
  setnames(a,5,'signal')
  setnames(a,6,'lnc')
  
  # model 1 which takes into account effect of treatment on lnc expression
  mod1a = with(a, lm(signal ~ age + gender + treat + lnc*treat))
  l1 = summary(mod1a)
  
  # model 2 doesn't take into consideration the interaction term
  mod1b = with(a, lm(signal ~ age + gender + treat ))  
  
  Corr = cor(x = a[,signal], y = a[,lnc], method = "spearman")
  meanGene = mean(a[,signal])
  meanLnc = mean(a[,lnc])
  Gene = as.character(gene.ann[which(gene.ann$ID %in% as.character(x$Genes[1])),3])
  Lnc = as.character(gene.ann[which(gene.ann$ID %in% as.character(x$lnc[1])),3])
  
  res = data.frame(
    Gene = Gene,
    Lnc = Lnc,
    SpearmanCorr = round(Corr,3),
    Mean_Gene = meanGene,
    Mean_Lnc = meanLnc,
    Lnc_Estimate = coef(l1)[5,1],
    Lnc_SE = coef(l1)[5,2],
    dxLnc_Estimate = coef(l1)[6,1],
    dxLnc_SE = coef(l1)[6,2],
    P = anova(mod1a,mod1b)$"Pr(>F)"[2] # Pvalue is calculated based on both models
  )
  
  if(res$P[1]<1e-06)
  {
    jpeg(file=paste(Gene,'_',Lnc,'.jpg',sep=''),800,800)
    p = ggplot(a, aes(x = signal,y = lnc))+
      geom_point(size = 4)+
      xlab(paste("\n",Gene))+
      ylab(paste(Lnc,"\n"))+
      geom_smooth(method = lm)+
      ggtitle(paste("P=",res$P[1],"\nSpearman=",round(Corr,3)))+
      theme(axis.title.x=element_text(size=14,color="black"),
            axis.text.x=element_text(size=14,color="black"),
            axis.title.y=element_text(size=14,color="black"),
            axis.text.y=element_text(size=14,color="black"),
            plot.title=element_text(size=16),
            legend.title=element_text(size=12),
            legend.text=element_text(size=12))
    print(p)
    dev.off()
  } 
  return(res)
}
