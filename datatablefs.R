
#data.table first steps

library(data.table)

#General form: DT[i, j, by]                
#“Take DT, subset rows using i, then calculate j grouped by by”

set.seed(45L)
DT <- data.table(V1=c(1L,2L),
                 V2=LETTERS[1:3],
                 V3=round(rnorm(4),4),
                 V4=1:12)


# Subconjunto de linhas - usando 1o atributo

DT[3:5,]
DT[3:5]

DT[V2=="C"] # filtrar linhas na coluna x
DT[V2 %in% c("A","C")]


# manipulando colunas - 2o atributo

DT[,V2]
class(DT[,.(V2,V3)]) # em mais de 1 coluna -> .(fun(c1),fun(c2))
DT[,sum(V1)]
DT[,.(sum(V1),sd(V3))]  
DT[,.(Aggregate=sum(V1),Sd.V3=round(sd(V3),2))]      
DT[,.(V1,Sd.V3=sd(V3))]
DT[,.(var = print(V2),plot(V3))]


# agrupandos por colunas - 3o atributo - by

DT[,.(V4.Sum=sum(V4)),by=V1] #Calculate sum of V4 for every group in V1
DT[,.(V4.Sum=sum(V4)),by=.(V1,V2)] # grupos de V1 e V2
DT[,.(V4.Sum=sum(V4)),by=sign(V1-1)]
DT[,.(V4.Sum=sum(V4)),by=.(V1.01=sign(V1-1))] 
DT[1:5,.(V3.Sum=round(sum(V3))),by=V1]
DT[,.N,by=V1] #numero de obs por grupo de V1

DT[,list(nome=mean(V3)),by=.(pri=V2,sec=V1)]


# fixando coluna
setkey(DT,V2)
DT["A"]











