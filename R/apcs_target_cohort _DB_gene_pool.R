
#this script plots the functional enrichments of the pool of target genes of 15 drugs obtained from the drug bank with the schizophrenia genes obtained from the open targets database.
#the objective is to find the cohort of genes with the highest pval

#necessary packages
library(data.table)
library(fgsea)
library(dplyr)
library(readr)
library(ggplot2)

#all genes associated with sch obtained from open targets
genes_sch <- readr::read_rds("all_genes_sch_OT")%>%
  dplyr::select(symbol)
#transformation to list
genes_sch_list <- list(genes_sch = genes_sch$Gene_Target)

#target genes of 15 apcs - obtained from the drugbank
Ap_DB <- readr::read_rds("Drugs_APCs_DB.rds")%>%
  dplyr::select(Drug,Gene_Target)
DB_list <- split(Ap_DB$Gene_Target, Ap_DB$Drug)

#universe of genes
reactome <- readr::read_rds("all_level_reactome.RDS")
universe <- unique(c(genes_sch$symbol,Ap_DB$Gene_Target,reactome$gene))

#creation of a gene pool
#here all target genes of the 15 apcs 
#have been merged into one gene pool (drug independent)

poll_genes_DB <- readr::read_rds('Drugs_APCs_DB.rds')
poll_genes_DB <- poll_genes_DB [!duplicated(poll_genes_DB$Gene_Target), ]%>%
  dplyr::select(Gene_Target)
#saving output
saveRDS(poll_genes_DB, "pool_genes_DB.rds")
#transformation to list
pool_genes_list <- as.list(pool_genes_DB)

#The enrich_drugs function is able to perform the external function (fgesea) for each drug
#enrich_drugs - function creation:
enrich_drugs <- function(drugs_list, pathways_genes, universe){
  gen_enriched_drugs <- data.table()
  
  for (i in 1:length(drugs_list)) {
    name <- names(drugs_list)[i]
    
    gen_enriched_drugs <- fora(pathways = pathways_genes, genes = drugs_list[[name]], universe = universe) %>%
      rbind(gen_enriched_drugs)
  }
  
  return(gen_enriched_drugs)
}

#the function coorte_enrich_drugs is able to run function enrich_drugs for different pools of genes associated 
#with schizophrenia - this pool being increased every 10 genes
#The function receives a quanti of genes and a database

coorte_enrich_drugs <- function(Qnt_genes, Genes_list){
  x <- 10
  y <- 1
  gen_enriched_drugs <- data.table()
  while (x <= Qnt_genes) { 
    genes_sch_list <- genes_sch[1:x,] %>%
      list()
    gen_enriched_drugs <- enrich_drugs(pool_genes_list, genes_sch_list, universe)%>%
      dplyr::select(pval,overlap,size)%>%
      dplyr::mutate(Loop = y)%>%
      dplyr::mutate(tamanho = x)%>%
      rbind(gen_enriched_drugs)
    
    x <- x + 10
    y <- y + 1
  }
  return(gen_enriched_drugs)
}

#For all schizophrenia genes how many genes = all database rows
Qnt_genes <- nrow(genes_sch)

pool_fora_results <- coorte_enrich_drugs(Qnt_genes, genes_sch_list)
#conversion from pval to -log in base 10
pool_fora_results$pval<- -log(x = pool_fora_results$pval, base = 10)
#saving output
saveRDS(pool_fora_results, "pool_fora_results.rds")

#Graphic#
#This graph plots the genes associated with schizophrenia by the value obtained in the enrichment
#the point where there is the highest p value is x = 220, y = 38.95800 (in red)
#the initially selected point (then discarded) - with 220 genes is x=130, y=36.88630 (in blue)
#the point where there are genes with overall greater than 0.5 is x=200, y=34.93693 (in orange)

pool_fora_results_plot <- ggplot(data = pool_fora_results) +
  aes(x=size, y=pval) + 
  geom_point()+
  geom_point(aes(x = 220, y= 38.95800),
         col = 'black',
         shape = 21,
         size = 2,
         fill = "red") +
  annotate("point", x=130, y=36.88630,
           col='black',
           shape=21,
           size=2,
           fill = 'blue')+
  annotate("point", x=200, y=34.93693,
           col='black',
           shape=21,
           size=2, 
           fill = "orange")+
  labs(title="Functional enrichment analysis - Gene pool",
       x="number of genes", y = "-log(p-valor)")
pool_fora_results_plot + theme_bw()
