#this script plots the functional enrichments of the pool of target genes of 15 drugs obtained from the drug bank with the schizophrenia genes obtained from the open targets database.
#the objective is to find the cohort of genes with the highest pval

setwd("")

#necessary packages
library(devtools)
library(readxl)
library(data.table)
library(dplyr)
library(writexl)
library(fgsea)
library(dplyr)
library(readr)
library(ggplot2)

# creation of a gene pool associated with drug bank antipsychotic drugs
poll_genes_DB <- read_rds("antipsychotic_drugs_DB.rds")
poll_genes_DB <- poll_genes_DB [!duplicated(poll_genes_DB$Gene_Target), ]%>%
  select(Gene_Target)

saveRDS(poll_genes_DB, file = "poll_genes_DB.rds")
poll_genes_DB <- read_rds("poll_genes_DB.rds")


# antipsychotic drugs (drug bank) - target genes of 15 apcs - obtained from the drugbank
ApDB <- read_rds("antipsychotic_drugs_DB.rds")%>%
  select(Drug,Gene_Target)
DB_list <- split(ApDB$Gene_Target, ApDB$Drug)
pool_genes_list <- as.list(poll_genes_DB)


# creation of genes universe 
Reactome <- read_rds("all_level_reactome.RDS")
universe <- unique(c(SchGenes$Gene_Target,ApDB$Gene_Target,Reactome$gene))

# function enrich_drugs - returns a data table that summarizes the results of pathway enrichment analysis for each drug in the drugs_list
enrich_drugs <- function(drugs_list, pathways_genes, universe){
  gen_enriched_drugs <- data.table()
  
  for (i in 1:length(drugs_list)) {
    name <- names(drugs_list)[i]
    
    gen_enriched_drugs <- fora(pathways = pathways_genes, genes = drugs_list[[name]], universe = universe) %>%
      rbind(gen_enriched_drugs)
  }
  
  return(gen_enriched_drugs)
}

# function coorte_enrich_drugs - this function is to run the enrich_drugs function on subsets of Genes_list consisting of 10, 20, 30, ... up to qnt_genes genes, and then combine the results into a single data table.
coorte_enrich_drugs <- function(qnt_genes, Genes_list){
  x <- 10
  y <- 1
  gen_enriched_drugs <- data.table()
  while (x <= qnt_genes) { 
    Sch_genes_list <- Genes_list[1:x,] %>%
      list()
    gen_enriched_drugs <- enrich_drugs(pool_genes_list, Sch_genes_list, universe)%>%
      select(pval,overlap,size)%>%
      mutate(Loop = y)%>%
      mutate(tamanho = x)%>%
      rbind(gen_enriched_drugs)
    
    x <- x + 10
    y <- y + 1
  }
  return(gen_enriched_drugs)
}

# all genes schizophrenia associated 
setwd("inputs")

all_genes_sch_OT <- as.data.frame(fread("MONDO_0005090-associated-diseases.tsv")) %>%
  select(symbol)
colnames(all_genes_sch_OT) [1] <- "Gene_Target"

qnt_genes <- nrow(all_genes_sch_OT)

pool_fora_results_all <- coorte_enrich_drugs(qnt_genes,all_genes_sch_OT)
View(pool_fora_results_all)
pool_fora_results_all$pval<- -log(x = pool_fora_results_all$pval, base = 10)
View(pool_fora_results_all)

# Graphic 
pool_fora_results_all_plot <- ggplot(data = pool_fora_results_all) +
  aes(x=size, y=pval) + 
  geom_point()+
  geom_point(aes(x = 220, y= 38.95800),
             col = 'black',
             shape = 21,
             size = 2,
             fill = "#E18AAA") +
  annotate("point", x=130, y=36.88630,
           col='black',
           shape=21,
           size=2,
           fill = '#3399FF')+
  labs(title="Functional enrichment analysis - Gene pool",
       x="Number of genes", y = "-log(p-valor)")
pool_fora_results_all_plot + theme_bw()



