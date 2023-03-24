# Project Title: The neuroimmune mechanisms of antipsychotic drugs: a network-medicine approach for repositioning antiinflammatory agents to treat Schizophrenia
This project aims to explore the neuroimmune mechanisms of antipsychotic drugs and genes associated with schizophrenia. It also seeks to identify potential anti-inflammatory agents that can be repositioned to treat schizophrenia. The project will use scripts in R and Python to analyze data from several public databases.

# Specific Objectives:
- Search for genes related to major antipsychotic drugs in public databases;
- Search for genes associated with schizophrenia in public databases;
- Obtain protein-protein interaction network for Network Medicine analyses;
- Analyze the relationship between antipsychotic target genes and genes associated with schizophrenia;
- Characterize the neuroimmune mechanisms of the target genes of antipsychotic drugs;
- Characterize the neuroimmune mechanisms of genes associated with schizophrenia;
- Finding drugs for repositioning with action on neuroimmune mechanisms of schizophrenia.

# Databases Used:
- DrugBank
- Comparative Toxicogenomics Database (CTD)
- Drug-Gene Interaction Database (DGIdb)
- The Open Targets database

# Scripts Used:
The project uses R and Python scripts to manipulate the databases and analyze the data.

# R Scripts:
- 'manipulate_banks.R': This script cleans and organizes the dataset coming from the Drugbank, CTD, and DGIdb databases that contain all drug-associated genes and selects the genes with an Overall score greater than in the Open Targets database.
- 'compare_datasets.R': This script compares the three datasets that contain all drug-associated genes.
- 'enrichment_analysis.R': This script generates a functional enrichment analysis for drug target genes related to 15 antipsychotic drugs from the three databases of schizophrenia genes obtained from the Open Targets database.
- 'plot_enrichments.R': This script plots the functional enrichments of the pool of target genes of 15 drugs obtained from the Drugbank, CTD, and DGIdb with the schizophrenia genes obtained from the Open Targets database. The objective is to find the cohort of genes with the highest p-value and compare the enrichments for the three datasets.
- 'path_enrichment_analysis.R': This script performs a path enrichment analysis using the Functional Gene Set Analysis (FGSEA) method for a set of genes associated with schizophrenia (obtained from the Open Targets database) and a set of drug target genes (obtained from the Drugbank database).

# Python Script:
- 'distance_calculation.py': This script defines two classes (DrugTarget and Interactome) and their related functions. Starting from a network file that maps the interactions between drugs and target proteins, it performs screening to verify if a set of genes interacts with a given drug and a network of protein-protein interactions. It has methods to calculate the proximity between two sets of proteins, as well as a method to calculate proximity z-score.

# How to Use:
To use this project, first ensure that you have the necessary software and packages installed to run R and Python scripts. Clone the repository and navigate to the folder where the scripts are located. Run the scripts in the order specified in the comments of the code. The output files will be saved in the specified directories.

# Data Sources:
The data used in this project is sourced from the following public databases:
- DrugBank: a comprehensive database of drug and drug target information
- Comparative Toxicogenomics Database (CTD): a public resource for the effects of environmental chemicals on human health
- Drug-Gene Interaction Database (DGIdb): a resource that consolidates information about drug-gene interactions and gene druggability
- The Open Targets database: a public database of evidence-based drug target associations.

# Results:
The results of this project will provide insights into the neuroimmune mechanisms of antipsychotic drugs and genes associated with schizophrenia. It will also identify potential anti-inflammatory agents that can be repositioned to treat schizophrenia.

# Acknowledgements:
This project was made possible with the support of the following organizations:
- Open Targets
- DrugBank
- CTD
- DGIdb

# Contact:
If you have any questions or feedback regarding this project, please contact the project lead at zairapinheiro12@gmail.com.
