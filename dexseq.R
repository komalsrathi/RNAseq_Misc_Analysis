# install & use DEXSeq
source("http://bioconductor.org/biocLite.R")
biocLite("DEXSeq")
library(DEXSeq)

# get python scripts directory
pythonScriptsDir = system.file( "python_scripts", package="DEXSeq" )
list.files(pythonScriptsDir)

#############################################################################################
# inDir = system.file("extdata", package="pasilla")
# countFiles = list.files(inDir, pattern="fb.txt$", full.names=TRUE)
# countFiles
# 
# flattenedFile = list.files(inDir, pattern="gff$", full.names=TRUE)
# flattenedFile

# sampleTable = data.frame(
#   row.names = c( "treated1", "treated2", "treated3",
#                  "untreated1", "untreated2", "untreated3", "untreated4" ),
#   condition = c("knockdown", "knockdown", "knockdown",
#                 "control", "control", "control", "control" ),
#   libType = c( "single-end", "paired-end", "paired-end",
#                "single-end", "single-end", "paired-end", "paired-end" ) )

# suppressPackageStartupMessages( library( "DEXSeq" ) )

# dxd = DEXSeqDataSetFromHTSeq(
#   countFiles,
#   sampleData=sampleTable,
#   design= ~sample + exon + condition:exon,
#   flattenedfile=flattenedFile )

# genesForSubset = read.table(
#   file.path(inDir, "geneIDsinsubset.txt"),
#   stringsAsFactors=FALSE)[[1]]
# dxd = dxd[geneIDs( dxd ) %in% genesForSubset,]
# head( counts(dxd), 5 )

# dxd = estimateSizeFactors(dxd)
# dxd = estimateDispersions( dxd )
# dxd = testForDEU( dxd )
# dxd = estimateExonFoldChanges( dxd, fitExpToVar="condition")
# DEXSeqResults( dxd )
#############################################################################################

# get sample info
# only condition & library type
# both should be factors
# the reference level for condition should be control
s <- read.csv('sample_phenoData.csv')
s$condition <- ifelse(s$status=="NF",yes="control",no="case")
s$libType <- "paired-end"
sampleTable1 <- s[,c(6,7)]
rownames(sampleTable1) <- s$sample_name
sampleTable1 <- sampleTable1[order(rownames(sampleTable1)),]
sampleTable1$condition <- as.factor(sampleTable1$condition)
sampleTable1$condition <- relevel(sampleTable1$condition,ref="control")
sampleTable1$libType <- as.factor(sampleTable1$libType)

# list of count files output from dexseq_count.py
countFiles1 <- list.files("counts", pattern="txt", full.names=T)


# name & path of the GFF file made using dexseq_prepare_annotation.py
flattenedFile1 <- list.files(pattern="gff$", full.names=TRUE)

# get counts
suppressPackageStartupMessages(library("DEXSeq"))
dxd1 <- DEXSeqDataSetFromHTSeq(countFiles1,
                               sampleData = sampleTable1,
                               design = ~sample+exon+condition:exon,
                               flattenedfile = flattenedFile1)

# Normalization
dxd1 <- estimateSizeFactors(dxd1)

# Dispersion Estimation
dxd1 <- estimateDispersions(dxd1)
plotDispEsts(dxd1)

# Test for differential expression
dxd1 <- testForDEU(dxd1)
dxd1 <- estimateExonFoldChanges(object=dxd1, fitExpToVar="condition")
dxr1 <- DEXSeqResults(dxd1)
table(dxr1$padj<=0.01)
table(tapply(dxr1$padj<=0.1, dxr1$groupID, any))
dxr1.df <- as.data.frame(dxr1)
dxr1.dff <- dxr1.df[-which(is.na(dxr1.df$control)),]

# for a particular gene, check for differential exon usage
plotDEXSeq( dxr1, "ENSG00000003987", legend=TRUE, cex.axis=1.2, cex=1.3, lwd=2 )
dxr1.df[grep("ENSG00000170873",dxr1.df$groupID),1:10]
