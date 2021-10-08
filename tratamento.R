#tratamento 0710

# objetivo:
# criar indicadores e chaves para as bases

# preparacao

# pasta de codigos github
setwd("C:/mark/imdsPOF")
# pasta com bases parquet (sinronizada com google drive)
dir = "C:/mark/estagioIMDS/driveImds/POF/bases/"

library(arrow)
library(data.table)
library(readr)
library(tidyverse)

# arquivos

# variaveis para tratar
vars <-  c("UF","ESTRATO_POF","TIPO_SITUACAO_REG","COD_UPA","NUM_DOM",
           "NUM_UC","COD_INFORMANTE","V0306","ANOS_ESTUDO","PESO",
           "PESO_FINAL","RENDA_TOTAL","INSTRUCAO","COMPOSICAO",
           "PC_RENDA_DISP","PC_RENDA_MONET","PC_RENDA_NAO_MONET","PC_DEDUCAO")

base <- read_parquet(paste0(dir,"MORADOR.gz.parquet"),
                     col_select = all_of(vars))

# INDICADORES PARA RECORTES  ########


# Escolaridade do responsável (RF) 
# Raça ou cor
# Sexo
# Faixa etária


# atualizar no local compartilhado
write_parquet(base,
              paste0(dir,"MORADOR.gz.parquet"), 
              compression = "gzip", compression_level = 5)








