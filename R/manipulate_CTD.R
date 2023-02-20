#This script cleans and organizes the dataset coming from the CTD - this dataset contains all drug-associated genes
#set working directory
setwd("")

#libraries
library(readxl)
library(dplyr)

#CTD table - CTD file (Downloaded Aug 29, 2022)
CTD_bank <- read.csv("CTD_D012559_ixns_20220829153116.csv")

# List of selected APCs
names_apcs <- c("Amisulpride", "Aripiprazole", "Asenapine", "Chlorpromazine", "Clozapine","Haloperidol", "Iloperidone","Lurasidone", "Olanzapine", "Paliperidone", "Quetiapine", "Risperidone", "Sertindole", "Ziprasidone","Zotepine")

#Created a list of 15 antipsychotic drugs and am using it to filter from the drug
saveRDS(names_apcs, file = "list_APCs.rds")

# Filter drugs, select columns of interest, create column for database name and remove duplicate data
filtered_drugs_CTD <- CTD_bank %>%
  filter(Chemical.Name %in% names_apcs) %>%
  dplyr::select(Chemical.Name, Gene.Symbol, Gene.ID,) %>%
  distinct() %>%
  mutate(Database = "CTD")

#Renaming columns for standardization
colnames(filtered_drugs_CTD) [1] <- "Drug"
colnames(filtered_drugs_CTD) [2] <- "Gene_Target"
colnames(filtered_drugs_CTD) [3] <- "entrez_id"

#saving output
saveRDS(filtered_drugs_CTD, file = "antipsychotic_drugs.rds")