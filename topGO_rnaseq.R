# topGO analysis on all expressed genes
topGO.func <- function(limma)
{
  all_genes <- limma$adj.P.Val
  names(all_genes) <- rownames(limma)
  
  fg <- limma[which(limma$adj.P.Val<0.05),]
  interesting_genes <- rownames(fg)
  geneList <- as.logical(names(all_genes) %in% interesting_genes)
  names(geneList) <- names(all_genes)
  
  topDiffGenes <- function(allScore) {
    return(geneList)
  }
  
  GOdata <- new ("topGOdata", 
                 ontology = "BP", 
                 allGenes = all_genes, 
                 geneSel = topDiffGenes,
                 nodeSize = 10, 
                 annot = annFUN.org,
                 mapping="org.Hs.eg.db", 
                 ID = "ensembl")
  
  resultKS.elim <- runTest(GOdata, algorithm = "elim", statistic = "ks")
  allRes <- GenTable(GOdata, elimKS = resultKS.elim, topNodes = length(usedGO(object = GOdata)))
  return(allRes)
}
