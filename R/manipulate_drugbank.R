#This script cleans and organizes the dataset coming from the Drugbank - this dataset contains all drug-associated genes

#set working directory
setwd("")

#libraries
library(readxl)
library(dplyr)

#Drugbank table - Drugbank file (Downloaded May 31, 2022)
drug_bank <- read.csv("DrugBank_myDBv5.csv")

# Delete lines that are not of interest
#Filter only drugs with approved status
drug_bank_filter <- drug_bank %>% filter(Approved == "approved") 

# List of selected APCs
#Created a list of 15 antipsychotic drugs and am using it to filter from the drug 
banknames_apcs <- read_rds("list_APCs.rds")

# Filter drugs, select columns of interest and create column for database name
filtered_drugs_APCs <- drug_bank_filter %>%
  filter(Name %in% names_apcs) %>%
  dplyr::select(Name,Gene_Target,entrez_id) %>%
  dplyr::mutate(Database = "Drug_bank")
colnames(filtered_drugs_APCs) [1] <- "Drug"

#saving output
saveRDS(filtered_drugs_APCs, file = "antipsychotic_drugs_DB.rds")