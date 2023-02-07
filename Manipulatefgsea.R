#Instalacao de pacotes BiocManager
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("fgsea")

#library 
library(devtools)
library(readxl)
library(data.table)
library(dplyr)
library(writexl)
library(fgsea)
library(dplyr)
library(readr)
library(tidyverse)

#Importanto meus dados --> nesse caso meus genes serão aqueles associados a esquizofrenia
#Transformar o dataframe dos genes em uma lista
sch_genes <- readr::read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/GenesAssociadosSCH_OT_All_0.5.rds")
schgenes_list <- list(schgenes_list = sch_genes$Gene_Target)

#Criaçaoo de um iniverso de genes 
Reactome <- readr::read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/all_level_reactome.RDS")
universe <- unique(c(sch_genes$Gene_Target,ApDGIdb$Gene_Target,Reactome$gene))



#Genes associados aos fármacos
ApDGIdb <- readr::read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/Drugs_APCs_DGIdb.rds")
DGIdb_list <- split(ApDGIdb$Gene_Target, ApDGIdb$Drug)

#enriquecimento - funcao fora - DGIdb
names(DGIdbList)
results <- data.table()

for (i in 1:length(DGIdb_list)) {
  name <- names(DGIdb_list)[i]
  results <- fora(pathways = SchGenes_Fora, genes = DGIdb_list[[name]], universe = universe) %>%
    dplyr::mutate(Drug = name) %>%
    rbind(results)
}


Fora_results_DGIdb <- results %>%
  dplyr::select(Drug,pval,overlap)%>%
  dplyr::mutate(Database = "DGIdb")
Fora_results_DGIdb$pval<- -log(x = Fora_results_DGIdb$pval, base = 10)

#Genes associados aos fármacos - DrugBank 
ApDB <- readr::read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/Farmacos_antipsicoticos_DB.rds")%>%
  dplyr::select(Drug,Gene_Target)
DB_list <- split(ApDB$Gene_Target, ApDB$Drug)

names(DB_list)
results <- data.table()

for (i in 1:length(DB_list)) {
  name <- names(DB_list)[i]
  results <- fora(pathways = SchGenes_Fora, genes = DB_list[[name]], universe = universe) %>%
    dplyr::mutate(Drug = name) %>%
    rbind(results)
}

Fora_results_DB <- results %>%
  dplyr::select(Drug,pval,overlap)%>%
  dplyr::mutate(Database = "DrugBank")
Fora_results_DB$pval<- -log(x = Fora_results_DB$pval, base = 10)


#Genes associados aos fármacos - CTD 
ApCTD <- readr::read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/Farmacos_antipsicoticos_CTD.rds")%>%
  dplyr::select(Drug,Gene_Target)
CTD_list <- split(ApCTD$Gene_Target, ApCTD$Drug)

names(CTD_list)
results <- data.table()

for (i in 1:length(CTD_list)) {
  name <- names(CTD_list)[i]
  results <- fora(pathways = SchGenes_Fora, genes = CTD_list[[name]], universe = universe) %>%
    dplyr::mutate(Drug = name) %>%
    rbind(results)
}

Fora_results_CTD <- results %>%
  dplyr::select(Drug,pval,overlap)%>%
  dplyr::mutate(Database = "CTD")
Fora_results_CTD $pval<- -log(x = Fora_results_CTD $pval, base = 10)


Fora_results_Banks <- rbind(Fora_results_DB, Fora_results_DGIdb, Fora_results_CTD, fill=TRUE)