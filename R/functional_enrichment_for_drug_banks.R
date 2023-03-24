#This script generates a functional enrichment analysis for drug target genes related to 15 antipsychotic drugs from 3 databases of schizophrenia genes 
#obtained from the open targets database

#necessary packages
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("fgsea")
install.packages("readr")

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
library(ggplot2)

#data import

##pathways genes## 
#In this case my pathway genes are all sch-associated genes
#Here I have selected all genes from open targets bank with overall score greater than 0.5
sch_genes <- readr::read_rds("C:/Users/zaira/dev/r/TCC/Data/sch_genes_OT_overall0.5.rds")
#transformation to list
sch_genes_list <- list(sch_genes = sch_genes$Gene_Target)

#Drug genes 
#Here I selected 3 banks (DGIdb, drug bank and CTD) and selected in these banks all the genes associated with selected apcs drugs
#DGIdb
Ap_DGIdb <- readr::read_rds("D:/TCC/R scripts/new_manipulate_drug_banks/outputs/antipsychotic_drugs_DGIdb.rds")
#transformation to list
DGIdb_list <- split(Ap_DGIdb$Gene_Target, Ap_DGIdb$Drug)
#DrugBank 
Ap_DB <- read_rds("D:/TCC/R scripts/new_manipulate_drug_banks/outputs/antipsychotic_drugs_DB.rds")%>%
  dplyr::select(Drug,Gene_Target)
#transformation to list
DB_list <- split(Ap_DB$Gene_Target, Ap_DB$Drug)
#CTD 
Ap_CTD <- read_rds("D:/TCC/R scripts/new_manipulate_drug_banks/outputs/antipsychotic_drugs_CTD.rds")%>%
  dplyr::select(Drug,Gene_Target)
#transformation to list
CTD_list <- split(Ap_CTD$Gene_Target, Ap_CTD$Drug)


#Universe for DGIdb
reactome <- readr::read_rds("all_level_reactome.RDS")
universe <- unique(c(sch_genes$Gene_Target,Ap_DGIdb$Gene_Target,reactome$gene))

#functional enrichment for DGIbd 
#Here a loop was created that runs the outside function (fgesea) for each drug 
#The same will be done for the other drug banks

names(DGIdb_list)
results <- data.table()

for (i in 1:length(DGIdb_list)) {
  name <- names(DGIdb_list)[i]
  results <- fgsea::fora(pathways = sch_genes_list, genes = DGIdb_list[[name]], universe = universe) %>%
    dplyr::mutate(Drug = name) %>%
    rbind(results)
}

fora_results_DGIdb <- results %>%
  dplyr::select(Drug,pval,overlap)%>%
  dplyr::mutate(Database = "DGIdb")

#conversion from pval to -log in base 10
fora_results_DGIdb$pval<- -log(x = fora_results_DGIdb$pval, base = 10)

#saving output
saveRDS(fora_results_DGIdb, file = "fora_results_DGIdb.rds")

#Universe for Drug Bank
universe <- unique(c(sch_genes$Gene_Target,Ap_DB$Gene_Target,reactome$gene))

#Drug Bank

names(DB_list)
results <- data.table()

for (i in 1:length(DB_list)) {
  name <- names(DB_list)[i]
  results <- fgsea::fora(pathways = sch_genes_list, genes = DB_list[[name]], universe = universe) %>%
    dplyr::mutate(Drug = name) %>%
    rbind(results)
}

fora_results_DB <- results %>%
  dplyr::select(Drug,pval,overlap)%>%
  dplyr::mutate(Database = "DrugBank")

#conversion from pval to -log in base 10
fora_results_DB$pval<- -log(x = fora_results_DB$pval, base = 10)

#saving output
saveRDS(fora_results_DB, file = "fora_results_DB.rds")


#Universe for CTD
universe <- unique(c(sch_genes$Gene_Target,Ap_CTD$Gene_Target,reactome$gene))

#CTD
names(CTD_list)
results <- data.table()

for (i in 1:length(CTD_list)) {
  name <- names(CTD_list)[i]
  results <- fgsea::fora(pathways = sch_genes_list, genes = CTD_list[[name]], universe = universe) %>%
    dplyr::mutate(Drug = name) %>%
    rbind(results)
}

fora_results_CTD <- results %>%
  dplyr::select(Drug,pval,overlap)%>%
  dplyr::mutate(Database = "CTD")

#saving output
saveRDS(fora_results_CTD, file = "fora_results_CTD.rds")

#conversion from pval to -log in base 10
fora_results_CTD$pval<- -log(x = fora_results_CTD$pval, base = 10)


# Here I rbind the results obtained for the 3 banks in the same data frame
fora_results_banks <- rbind(fora_results_DGIdb, fora_results_CTD , fora_results_DB, fill=TRUE)

#saving output
saveRDS(fora_results_banks, file = "fora_results_banks.rds")


#Graphics#
#Here, two bar graphs were plotted to compare the databases with each other.
setdw(ForaResults_Banks)
fora_results_banks <- readr::read_rds("fora_results_banks.rds")%>%
  dplyr::select(Drug,pval,overlap,Database)
#pval X database
fora_results_banks_plot_pval <- fora_results_banks%>%
  ggplot( aes(x = reorder(Drug, -pval),  y = pval, label = pval, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  scale_fill_manual(values=c("#E18AAA", "#66CC99", "#3399FF"))+
  labs(title="Functional enrichment analysis", 
       x="Drugs", y = "-log(p-valor)")+
  theme_minimal()
fora_results_banks_plot_pval
fora_results_banks_plot_pval+ coord_flip()

#overlap X database
fora_results_banks_plot_overlap <- ggplot(data=fora_results_banks ,aes(x = Drug,  y = overlap, label = overlap, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_manual(values=c("#E18AAA", "#66CC99", "#3399FF"))+
  labs(title="Functional enrichment analysis", 
       x="Drugs", y = "Number of target genes in sch (overlap)")+
  theme_minimal()
fora_results_banks_plot_overlap
fora_results_banks_plot_overlap + coord_flip()

#boxplot
boxplot(pval~Database, data = fora_results_banks, 
        xlab = "Data base",
        ylab = "-log(p-valor)", 
        varwidth = TRUE, 
        col = "white",
        border=c("#E18AAA", "#66CC99", "#3399FF")
)
stripchart(fora_results_banks$pval ~ fora_results_banks$Database, add = TRUE, vertical = TRUE,
           method = "jitter",  col = c("#E18AAA", "#66CC99", "#3399FF"), pch = 19)
