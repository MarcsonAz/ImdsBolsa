#tratamento

# criar indicadores e chaves para as bases

# Organizacao das bases

# INDICADORES PARA RECORTES  ########


# Escolaridade do responsável (RF) 
# Raça ou cor
# Sexo
# Faixa etária


dir = "C:/mark/estagioIMDS/POF/base/base_rds/"

library(readr)
library(tidyverse)

base_morador <- read_rds(paste0(dir,"MORADOR.rds"))




names(base_morador)
