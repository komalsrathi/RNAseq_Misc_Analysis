# expr is the model
# dat is the input expression matrix
# pData is the sample information
# cont is for contrasts
# tmp <- diffexp.func(expr = '~0+treat+age+gender+site', dat = voom.data.expr, pData = pData, cont1 = 'treatDisease', cont2 = 'treatNormal')

diffexp.func <- function(expr,dat,pData,cont1,cont2)
{
  cont <- paste(cont1,"-",cont2, sep="")
  expr <- eval(parse(text=expr))
  design = model.matrix(expr, data = pData)
  fit = lmFit(dat, design = design)
  contrast.matrix = makeContrasts(contrasts = cont, levels = design)
  fit2 = contrasts.fit(fit, contrast.matrix)
  fit2 = eBayes(fit2)
  res = toptable(fit = fit2, number = Inf, adjust.method = "BH",p.value = 1) 
  res$FC = 2^(abs(res$logFC))
  res$FC = ifelse(res$logFC<0,res$FC*(-1),res$FC*1)
  return(res)
}
