# The DiffTest function can also be used to find miRNA and Target correlation

DiffTest <- function(x)
{
  expr = paste("a=alldata[,list(sample.name,age,gender,",as.character(x$Genes[1]),',',as.character(x$miRNA[1]),")]",sep='')
  eval(parse(text=expr))
  setnames(a,4,'signal')
  setnames(a,5,'mir')
  
  mod1a = with(a, lm(signal ~ age + gender + mir))
  l1 = summary(mod1a)
  
  res = data.frame(
    mir_beta = coef(l1)[4,1],
    mir_SE = coef(l1)[4,2],
    mir_Pval = coef(l1)[4,4],
    R.squared = l1$r.squared
  )
  return(res)
}

r = ddply(.data = table, .variables = .(miRNA,Genes), .fun = DiffTest,.parallel=TRUE)

# alldata is a big dataframe, with samplename, age, gender and expression of every gene that you want to test
# table is a 2 column table of miRNA and Target Genes
