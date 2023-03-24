#This script cleans and organizes the dataset coming from the Drugbank, CTD and DGIdb - these dataset contains all drug-associated genes

#set working directory

setwd("")

#libraries
library(readxl)
library(dplyr)
library(data.table)
library(tidyverse)

# List of selected APCs
#Created a list of 15 antipsychotic drugs and am using it to filter from the drug 
names_apsc <- readRDS("list_APCs.rds")

#For DrugBank

#Drugbank table - Drugbank file (Downloaded May 31, 2022)
drug_bank <- read.csv("DrugBank_myDBv5.csv")

#Filter only drugs'type'  'Polypeptide'
drug_bank_filtered <- drug_bank %>% filter(Type == "Polypeptide") 

# Filter drugs, select columns of interest, remove duplicate data create column for database name
filtered_drugs_DB <- drug_bank_filtered %>%
  filter(Name %in% names_apsc) %>%
  dplyr::select(Name,Gene_Target,entrez_id, ID)%>%
  distinct()%>%
  dplyr::mutate(Database = "Drug_bank")
colnames(filtered_drugs_DB) [1] <- "Drug" #Renaming columns for standardization

# saving output
saveRDS(filtered_drugs_DB, file = "antipsychotic_drugs_DB.rds")

# Group and count genes by drugs
count_drugs <- filtered_drugs_DB %>%
  group_by(Drug)%>%
  count()
View(count_drugs)
saveRDS(count_drugs, file = "count_antipsychotic_drugs_DB.rds")

# For CTD 

#CTD table - CTD file (Downloaded Aug 29, 2022)
CTD_bank <- read.csv("CTD_D012559_ixns_20220829153116.csv")

# Filter drugs, select columns of interest, create column for database name and remove duplicate data
filtered_drugs_CTD <- CTD_bank %>%
  filter(Chemical.Name %in% names_apsc) %>%
  dplyr::select(Chemical.Name, Gene.Symbol, Gene.ID,) %>%
  distinct() %>%
  mutate(Database = "CTD")

#Renaming columns for standardization
colnames(filtered_drugs_CTD) [1] <- "Drug"
colnames(filtered_drugs_CTD) [2] <- "Gene_Target"
colnames(filtered_drugs_CTD) [3] <- "entrez_id"

#saving output
saveRDS(filtered_drugs_CTD, file = "antipsychotic_drugs_CTD.rds")

# Group and count genes by drugs
count_drugs <- filtered_drugs_CTD %>%
  group_by(Drug)%>%
  count()
View(count_drugs)
saveRDS(count_drugs, file = "count_antipsychotic_drugs_CTD.rds")

# For DGIdb

# DGIdb table - DGIdb file (Downloaded Sep 21, 2022)
DGIdb <- as.data.frame(fread("interactions.tsv"))
DGIdb$drug_name <- str_to_title(tolower(DGIdb$drug_name))
#As drug names are in capital letters, we adjusted them to lower case. Note that the tolower() function converts all letters in the text column to lowercase, and the str_to_title() function converts the first letter of each word to uppercase.

# Filter drugs, select columns of interest, create column for database name and remove duplicate data
filtered_drugs_DGIdb <- DGIdb %>%
  filter(drug_name %in% names_apsc)%>%
  dplyr::select(drug_name,gene_name)%>%
  distinct()

#Renaming columns for standardization
colnames(filtered_drugs_DGIdb) [1] <- "Drug"
colnames(filtered_drugs_DGIdb) [2] <- "Gene_Target"

saveRDS(filtered_drugs_DGIdb, file = "antipsychotic_drugs_DGIdb.rds")

# Group and count genes by drugs
count_drugs <- filtered_drugs_DGIdb %>%
  group_by(Drug)%>%
  count()
View(count_drugs)
saveRDS(count_drugs, file = "count_antipsychotic_drugs_DGIdb.rds")

