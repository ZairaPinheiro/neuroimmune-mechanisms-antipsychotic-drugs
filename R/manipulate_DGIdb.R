#set working directory
setwd("")

#libraries
library(readxl)
library(dplyr)
library(data.table)
library(tidyverse)

# List of selected APCs
names_apcs <- c("AMISULPRIDE", "ARIPIPRAZOLE","ASENAPINE", "CHLORPROMAZINE", "CLOZAPINE","HALOPERIDOL", "ILOPERIDONE", "LURASIDONE", "OLANZAPINE", "PALIPERIDONE", "QUETIAPINE","RISPERIDONE","SERTINDOLE","ZIPRASIDONE","ZOTEPINE")

# Filter drugs, select columns of interest, create column for database name and remove duplicate data
filtered_drugs_DGIdb <- as.data.frame(fread("interactions.tsv"))%>%
  filter(drug_name %in% names_apcs)%>%
  dplyr::select(drug_name,gene_name)%>%
  distinct()

#Renaming columns for standardization
colnames(filtered_drugs_DGIdb) [1] <- "Drug"
colnames(filtered_drugs_DGIdb) [2] <- "Gene_Target"

saveRDS(Interactions_DGIdb, file = "antipsychotic_drugs_DGIdb.rds")

