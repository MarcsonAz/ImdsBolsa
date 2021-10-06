# analise inicial de dados para bater com 
# publicacoes de primeiros resultados 


dir = "C:/mark/estagioIMDS/POF/base/base_rds/"

library(readr)
library(tidyverse)

base_morador <- read_rds(paste0(dir,"MORADOR.rds"))


# distribuição dentro da unidade de consumo

base_morador %>% group_by(V0306) %>% summarise(p=sum(PESO_FINAL))

# qtd de resp, corresponde ao numero de familias
# nuc: 69017704

# N: 207103790
# pessoa por UC: N/nuc: 3.000734 

# confirmado na tabela 2.1.1

# definir chave da unidade de consumo
base_morador %>% group_by(V0306) %>% summarise(n=n())

base_morador <- base_morador %>% mutate(
  chavedom = paste0(COD_UPA,NUM_DOM),
  chaveuc = paste0(COD_UPA,NUM_DOM,NUM_UC),
  one=1
)

dim(base_morador %>% group_by(chaveuc) %>% summarise(n=n()))
# check;  58039  2


# numero de moradores da uc
base_morador <- base_morador %>%
  group_by(chaveuc) %>%  mutate(
  num_morador = sum(one)
)


# cor, sexo, ER, ruralx urbana

# rural x urbana

a = base_morador %>% group_by(TIPO_SITUACAO_REG,V0306,V0404) %>% summarise(p=sum(PESO_FINAL))

# urbana: 59512143
# rural: 9505562

a = base_morador %>% group_by(V0404) %>% summarise(p=sum(PESO_FINAL))



# renda

# ordenar renda total

#renda = base_morador %>% filter(V0306==1) %>% select(chaveuc,RENDA_TOTAL) 

qq = MetricsWeighted::weighted_quantile(base_morador$RENDA_TOTAL,
                                        w = base_morador$PESO_FINAL,
                                        probs = seq(0,1,0.1))
#     20%     80% 
#   1800.28   7125.75

base_morador <- base_morador %>% mutate(
  rendaq1 = ifelse(RENDA_TOTAL<qq[3],1,0),
  rendaq5 = ifelse(RENDA_TOTAL>=qq[9],1,0)
)


####  sincronizar local e LP regionalizada - identificar RMs  ########

LPregionalizada <- read_table(
  "C:/mark/estagioIMDS/pnadc/LPregionalizada.txt", locale = locale(
    decimal_mark = ",",grouping_mark = "."))

# criar variaveis de apoio para definir a variavel local
# que receberá o merge das linhas


# definir grande regiao junto com tipo de area: local
# pegar rio e sp com tipo de area: rio_sp
# definir rms

listarms <- c(
  "Região Metropolitana de Rio de Janeiro (RJ)",
  "Região Metropolitana de São Paulo (SP)",
  "Região Metropolitana de Belo Horizonte (MG)" ,
  "Região Metropolitana de Salvador (BA)",
  "Região Metropolitana de Porto Alegre (RS)",
  "Região Metropolitana de Curitiba (PR)",
  "Região Metropolitana de Fortaleza (CE)",
  "Região Metropolitana de Recife (PE)",
  "Região Metropolitana de Belém (PA)")

base <- base_morador %>% mutate(TIPO_SITUACAO_REG = factor(
  TIPO_SITUACAO_REG, levels = 1:2, labels = c("Urbana","Rural")))


base <- base_morador %>% mutate(
  gr = str_sub(ESTRATO_POF,1,1),
  uf = str_sub(ESTRATO_POF,1,2),
  local = paste0(gr,TIPO_SITUACAO_REG),
  rio_sp = case_when(
    str_sub(ESTRATO_POF,1,2) == 33 ~ paste0("rj",TIPO_SITUACAO_REG),
    str_sub(ESTRATO_POF,1,2) == 35 ~ paste0("sp",TIPO_SITUACAO_REG),
    TRUE ~ "0"
  ),
  rms = case_when(
    str_sub(ESTRATO_POF,1,2) == 53 ~ "dfrm",
    RM_RIDE == listarms[1] ~ "rjrm",
    RM_RIDE == listarms[2] ~ "sprm",
    RM_RIDE == listarms[3] ~ "bhrm",
    RM_RIDE == listarms[4] ~ "sarm",
    RM_RIDE == listarms[5] ~ "parm",
    RM_RIDE == listarms[6] ~ "curm",
    RM_RIDE == listarms[7] ~ "form",
    RM_RIDE == listarms[8] ~ "rerm",
    RM_RIDE == listarms[9] ~ "berm",
    TRUE ~ "0"
  )
)


# preencher rio_sp com as rms
# e depois preencher local com o resultados de rio_sp

base <- base %>% mutate(
  rio_sp = ifelse(rms!="0",rms,rio_sp)
)

base <- base %>% mutate(
  local = ifelse(rio_sp!="0",rio_sp,local)
)

#merge
base <- left_join(base,LPregionalizada)




base <- base %>% mutate(
  pobre = ifelse(VDI5008<linhas,1,0)
)


## saida ##########


saida <- base_morador %>% group_by(TIPO_SITUACAO_REG,V0404,V0405,ER,
                                   rendaq1,rendaq5,V0306) %>% 
  summarise(pop = sum(PESO_FINAL))

openxlsx::write.xlsx(saida,"tabela1_pof.xlsx")



c = base_morador %>% group_by(V0306==1,V0415) %>% summarise(p=sum(one))


#################################################


#  DESPESA INDIVIDUAL

base_individual <- read_rds(paste0(dir,"DESPESA_INDIVIDUAL.rds"))

base_coletiva <- read_rds(paste0(dir,"DESPESA_COLETIVA.rds"))

#d = base_individual %>% group_by(V0306,V9001) %>% summarise(n=n())







