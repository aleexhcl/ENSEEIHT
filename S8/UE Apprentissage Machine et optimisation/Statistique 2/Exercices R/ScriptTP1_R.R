#Script TP1-R HPC-BigData 2022

##1##
an=1880:2022                             
bis=((an%%4==0) & (an%%100!=0)) | (an%%400==0)
i=which(bis==TRUE)
an[i]
#ou, plus simplement : 
an[bis]


##2##
A=matrix(runif(12000),nrow=12) 
hist(A) 
MoyA=apply(A,2,mean) 
hist(MoyA) 


##3##
data(iris)
summary(iris)

iris2=iris[iris[,5]=="versicolor",]
#ou
iris2=iris[iris$Species=="versicolor",]
#ou
iris2=subset(iris,Species=="versicolor")

iris2[order(iris2[,1],decreasing=TRUE),]
#ou
iris2[order(iris2$Sepal.Length,decreasing=TRUE),]


##4##
data=read.table(file="ozone.txt",header=T)

summary(data)

data$maxO3[data$T15>30]

data2=subset(data,pluie=="Sec")

data2[order(data2$T12,decreasing=T),]

par(mfrow=c(1,2))
hist(data$Ne9) ; boxplot(data$Ne9) 

quantile(data$maxO3,probs=seq(0.1,0.9,0.1))


##5##

#1) 
data=read.table("CLIM.txt",sep=";",dec=",",header=T)

dim(data)
names(data)
head(data) ; tail(data)
summary(data)

#2) 
data$AN=as.numeric(substr(data$DATE,1,4))
data$MOIS=as.numeric(substr(data$DATE,5,6))
#ou 
data$AN=data$DATE%/%10000
data$MOIS=(data$DATE%/%100)%%100

#3)
agen=subset(data,POSTE==47091001)
toul=data[data$POSTE==31069001,]                   

#4)
agen[agen$TX==max(agen$TX),c("DATE","TX")]
#19820708  
# 38.8

toul[toul$TX==max(toul$TX),c("DATE","TX")]
#19820708
#40.2

#5)
par(mfrow=c(1,2))
hist(agen$TX) ; hist(toul$TX)

xx=seq(-9,41,2)
hist(agen$TX,main="Agen 1971-2000",xlab="TX en °C",ylab="Effectif", breaks=xx, col="blue")
hist(toul$TX,main="Toulouse 1971-2000",xlab="TX en °C",ylab="Effectif", breaks=xx, col="red") 


#6)
matrice=function(nom,num) {
n=max(nom$AN)-min(nom$AN)+1
tab=matrix(nrow=n,ncol=13)
for(i in 1:n) {
yy=min(nom$AN)+i-1
	for(j in 1:12) {
	tab[i,j]=mean(nom[(nom$AN==yy)&(nom$MOIS==j),num])
	}
tab[i,13]=mean(nom[nom$AN==yy,num])
}
return(tab)
}

#7)
toulTX=matrice(toul,5)
max(toulTX[,-13]) #31.09677
max(toulTX[,13]) #19.69178

agenTX=matrice(agen,5)
max(agenTX[,-13]) #30.66452
max(agenTX[,13]) #19.66082

#8)
boxplot(toulTX[,13],agenTX[,13],names=c("Toulouse","Agen"),main="Moyenne annuelle TX")
