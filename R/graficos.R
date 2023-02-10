library(readxl)
library(data.table)
library(dplyr)
library(tidyverse)
library(ggplot2)

#Importar dados   
Genes_in_SCH_DGIdb <- read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/Farmacos_antipsicoticos_DGIdb.rds")
Genes_in_SCH_DB <- read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/Genes_in_SCH_DB.rds")
Genes_in_SCH_CTD <- read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/Genes_in_SCH_CTD.rds")

#RBind dos dados
Genes_in_SCH <- rbind(Genes_in_SCH_DGIdb, Genes_in_SCH_DB, Genes_in_SCH_CTD)
saveRDS(Genes_in_SCH, file = ("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/Genes_in_SCH_todos.rds"))
View(Genes_in_SCH)


grafico_barras <- Genes_in_SCH%>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH, label = N_Genes_SCH, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_manual(values=c("#0066CC", "#330099", "#FF66FF"))+
  ylab("N?mero de genes alvos na Esquizofrenia")+
  xlab("F?rmacos")+
  theme_minimal()
grafico_barras
grafico_barras + coord_flip()

grafico_barras2 <- ggplot(data=Genes_in_SCH,aes(x = Drug,  y = N_Genes_SCH, label = N_Genes_SCH, fill = Database)) +
  
#English
  grafico_barrasEN <- Genes_in_SCH%>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH, label = N_Genes_SCH, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_manual(values=c("#0066CC", "#330099", "#FF66FF"))+
  ylab("Number of target genes in schizophrenia")+
  xlab("Drugs")+
  theme_minimal()
grafico_barrasEN
grafico_barrasEN + coord_flip()

install.packages("forcats")
library(forcats)

#Gr?fico com cores diferentes 
Genes_in_SCH %>%
  mutate(Drug = fct_reorder(Drug, N_Genes_SCH)) %>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH, label = N_Genes_SCH, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_brewer(palette="YlGnBu")+
  ylab("N?mero de genes na Esquizofrenia")+
  xlab("F?rmacos")+
  theme_light()+
  coord_flip()

Genes_in_SCH %>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH, label = N_Genes_SCH, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_brewer(palette="YlGnBu")+
  ylab("N?mero de genes alvos na Esquizofrenia")+
  xlab("F?rmacos")+
  theme_minimal()+
  coord_flip()

#Gr?fico com Drug Bank
Genes_in_SCH_DB%>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH)) +
  geom_bar(stat="identity", fill="#3399FF", position=position_dodge())+
  geom_text(aes(label=N_Genes_SCH), vjust=1.6, color="white",
            position = position_dodge(0.9), size=1.5)+
  ylab("N?mero de genes alvos na Esquizofrenia")+
  xlab("F?rmacos")+
  theme_minimal()+
  coord_flip()

#Gr?fico com CTD
Genes_in_SCH_CTD%>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH)) +
  geom_bar(stat="identity", fill="#FFFFCC", position=position_dodge())+
  geom_text(aes(label=N_Genes_SCH), vjust=1.6, color="black",
            position = position_dodge(0.9), size=1.5)+
  ylab("N?mero de genes alvos na Esquizofrenia")+
  xlab("F?rmacos")+
  theme_minimal()+
  coord_flip()

#Gr?fico com DGIdb
Genes_in_SCH_DGIdb%>%
  ggplot( aes(x = reorder(Drug, -N_Genes_SCH),  y = N_Genes_SCH)) +
  geom_bar(stat="identity", fill="#66CC99", position=position_dodge())+
  geom_text(aes(label=N_Genes_SCH), vjust=1.6, color="black",
            position = position_dodge(0.9), size=1.5)+
  ylab("N?mero de genes alvos na Esquizofrenia")+
  xlab("F?rmacos")+
  theme_minimal()+
  coord_flip()


#Fora Results p-valor - Gr?fico de barras 
ForaResults_Banks <- read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/ForaResults_Banks.rds")%>%
  dplyr::select(Drug,pval,Database)
ForaResults_Banks_Plot <- ForaResults_Banks%>%
  ggplot( aes(x = reorder(Drug, -pval),  y = pval, label = pval, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  scale_fill_brewer(palette="YlGnBu")+
  labs(title="An?lise de enriquecimento funcional", 
           x="F?rmacos", y = "-log(p-valor)")+
  theme_minimal()
ForaResults_Banks_Plot
ForaResults_Banks_Plot + coord_flip()

#Fora Results overlap - Gr?fico de barras 
ForaResults_Banks <- read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/ForaResults_Banks.rds")%>%
  select(Drug,overlap,Database)

View(ForaResults_Banks)
ForaResults_Banks_Plot <- ggplot(data=ForaResults_Banks ,aes(x = Drug,  y = overlap, label = overlap, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_brewer(palette="PuRd")+
  labs(title="An?lise de enriquecimento funcional", 
       x="F?rmacos", y = "N?mero de genes alvos na Esquizofrenia (overlap)")+
  theme_minimal()
ForaResults_Banks_Plot
ForaResults_Banks_Plot + coord_flip()

ForaResults_Banks_Plot <- ForaResults_Banks %>%
  ggplot( aes(x = reorder(Drug, -overlap),  y = overlap, label = overlap, fill = Database)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  geom_text(position = position_dodge2(width = 0.9, preserve = "single"), angle = 0, vjust=0.5, size=1.5)+
  scale_fill_manual(values=c("#0066CC", "#330099", "#FF66FF"))+
  labs(x="F?rmacos", y = "N?mero de genes alvos na Esquizofrenia (overlap)")+
  theme_minimal()
ForaResults_Banks_Plot
ForaResults_Banks_Plot + coord_flip()


#Teste GGPLOT
library(RColorBrewer) 
nb.cols <- 15
mycolors <- colorRampPalette(brewer.pal(9, "YlGnBu"))(nb.cols)

ForaResults_Banks <- read_rds("C:/Users/Zaira Pinheiro/OneDrive/Documentos/TCC/Projeto TCC/Data/ForaResults_Banks.rds")%>%
  dplyr::select(Drug,pval,Database)
ForaResults_Banks_Plot <- ForaResults_Banks%>%
  ggplot(aes(x = Database,  y = pval, label = pval, fill = Drug)) +
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  scale_fill_manual(values = mycolors)+
  labs(title="An?lise de enriquecimento funcional", 
       x="Banco de dados", y = "-log(p-valor)")+
  theme_minimal()
ForaResults_Banks_Plot <- ForaResults_Banks_Plot + guides(fill=guide_legend(title="F?rmacos"))
ForaResults_Banks_Plot
ForaResults_Banks_Plot + coord_flip()


#BoxPlot - Fora Results p-valor
Boxplot <- boxplot(pval~Database,
data=ForaResults_Banks,
main="An?lise de enriquecimento funcional",
xlab="Database",
ylab="-log(p-valor)",
col="orange",
border="brown"
)

boxplot(pval~Database, data = ForaResults_Banks, 
        xlab = "Database",
        ylab = "-log(p-valor)", 
        main = "An?lise de enriquecimento funcional",
        varwidth = TRUE, 
        col = c("green","red","purple")
)
stripchart(ForaResults_Banks$pval ~ ForaResults_Banks$Database, vertical = TRUE, method = "jitter",
           pch = 19, add = TRUE, col = 1:length(levels(ForaResults_Banks$pval)))

#BoxPlot - Fora Results p-valor ==> Cores padr?o 

boxplot(pval~Database, data = ForaResults_Banks, 
        xlab = "Database",
        ylab = "-log(p-valor)", 
        main = "An?lise de enriquecimento funcional",
        varwidth = TRUE, 
        col = "white",
        border=c("#FFFFCC", "#66CC99", "#3399FF")
)
stripchart(ForaResults_Banks$pval ~ ForaResults_Banks$Database, add = TRUE, vertical = TRUE,
           method = "jitter",  col = c("#FFCC99", "#66CC99", "#3399FF"), pch = 19)

# Different fill color


ch <- ggplot(ForaResults_Banks,aes(x=Database,y=pval,fill=Database))+
  labs(title="An?lise de enriquecimento funcional", 
       x="DataBase", y = "-log(p-valor)")+
  geom_boxplot()
ch

#Em ingl?s - BoxPlot - Fora Results p-valor ==> Cores padr?o 
boxplot(pval~Database, data = ForaResults_Banks, 
        xlab = "Database",
        ylab = "-log(p-value)", 
        main = "Gene Set Enrichment Analysis",
        varwidth = TRUE, 
        col = "white",
        border=c("#FFFFCC", "#66CC99", "#3399FF")
)
stripchart(ForaResults_Banks$pval ~ ForaResults_Banks$Database, add = TRUE, vertical = TRUE,
           method = "jitter",  col = c("#FFCC99", "#66CC99", "#3399FF"), pch = 19)


