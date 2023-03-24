#set working directory

setwd("")


#libraries
library(readxl)
library(data.table)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(gridExtra)

# open Targets table - Open Targets Schizophrenia genes (Downloaded Jan 18, 2023)
all_sch_genes_OT <- as.data.frame(fread("D:/TCC/R scripts/new_manipulate_drug_banks/inputs/MONDO_0005090-associated-diseases.tsv"))%>%
  select(symbol,overallAssociationScore, targetName)

#Here, only genes with an overall score greater than 0.5 were selected.
sch_genes_OT <- all_sch_genes_OT[which(all_sch_genes_OT[,2]>=0.5),] 
colnames(sch_genes_OT) [1] <- "Gene_Target"
View(sch_genes_OT)

saveRDS(sch_genes_OT, file = "C:/Users/zaira/dev/r/TCC/Data/sch_genes_OT_overall0.5.rds")

# comparing schizophrenia genes with drug target genes for each drug bank

#DB
antipsychotic_drugs_DB <- read_rds("D:/TCC/R scripts/new_manipulate_drug_banks/outputs/antipsychotic_drugs_DB.rds")

genes_in_sch_DB <- sch_genes_OT %>%
  select(Gene_Target) %>%
  merge(antipsychotic_drugs_DB, by = "Gene_Target", all.x = TRUE) %>%
  na.omit() %>%
  select(Drug,Gene_Target,entrez_id, Database) %>%
  group_by(Drug) %>%
  count(Drug)%>%
  mutate(Database = "Drug bank")
colnames(genes_in_sch_DB) [2] <- "N_Genes_SCH"

#CTD
antipsychotic_drugs_CTD <- readRDS("D:/TCC/R scripts/new_manipulate_drug_banks/outputs/antipsychotic_drugs_CTD.rds")

genes_in_sch_CTD <- sch_genes_OT %>%
  select(Gene_Target)%>%
  merge(antipsychotic_drugs_CTD, by = "Gene_Target", all.x = TRUE)%>%
  na.omit()%>%
  select(Drug,Gene_Target)%>%
  group_by(Drug)%>%
  count(Drug)%>%
  mutate(Database = "CTD")
colnames(genes_in_sch_CTD) [2] <- "N_Genes_SCH"

#DGIDB
antipsychotic_drugs_DGIdb <- readRDS("D:/TCC/R scripts/new_manipulate_drug_banks/outputs/antipsychotic_drugs_DGIdb.rds")

genes_in_sch_DGIdb <- sch_genes_OT %>%
  select(Gene_Target)%>%
  merge(antipsychotic_drugs_DGIdb, by = "Gene_Target", all.x = TRUE)%>%
  na.omit()%>%
  select(Drug,Gene_Target)%>%
  group_by(Drug)%>%
  count(Drug)%>%
  mutate(Database = "DGIdb")
colnames(genes_in_sch_DGIdb) [2] <- "N_Genes_SCH"

# Grouping the 3 data frames of data to compare them
genes_in_sch <- rbind(genes_in_sch_DB,genes_in_sch_CTD, genes_in_sch_DGIdb)
View(genes_in_sch)

# bar_graph
bar_graph <- genes_in_sch%>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH, label = N_Genes_SCH, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_manual(values=c("#E18AAA", "#66CC99", "#3399FF"))+
  ylab("Number of target genes in schizophrenia")+
  xlab("Drugs")+
  theme_bw()+
  guides(fill = "none")
bar_graph
bar_graph + coord_flip()

fora_results_banks <- read_rds(file = "D:/TCC/R scripts/functional_enrichment_for_drug_banks/Outputs/fora_results_banks.rds")

#boxplot - functional_enrichment_for_drug_banks
boxplot(pval~Database, data = fora_results_banks, 
        xlab = "Database",
        ylab = "-log(p-valor)", 
        varwidth = TRUE, 
        col = "white",
        border=c("#E18AAA", "#66CC99", "#3399FF")
)
stripchart(fora_results_banks$pval ~ fora_results_banks$Database, add = TRUE, vertical = TRUE,
           method = "jitter",  col = c("#E18AAA", "#66CC99", "#3399FF"), pch = 19)



boxplot_grap <- ggplot(fora_results_banks, aes(x = Database, y = pval, fill = Database)) +
  geom_boxplot(varwidth = TRUE, outlier.shape = NA, color = "black") +
  geom_jitter(aes(color = Database), width = 0.2, height = 0, alpha = 0.8) +
  labs(x = "Database", y = "-log(p-valor)") +
  scale_fill_manual(values = c("#E18AAA", "#66CC99", "#3399FF")) +
  scale_color_manual(values = c("black", "black", "black")) +
  theme_bw()

# Merge the two graphs together for comparison
grid.arrange(bar_graph + coord_flip(), boxplot_grap, ncol = 2)



