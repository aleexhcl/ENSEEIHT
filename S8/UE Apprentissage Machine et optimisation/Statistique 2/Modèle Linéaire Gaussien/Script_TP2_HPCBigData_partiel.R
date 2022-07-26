# Script TP2 HPC-BigData - Modele linaire gaussien

# 1 - Chargement librairies et donnees


data=read.table(file="DataTP.txt",header=TRUE)

names(data)
summary(data)
dim(data)

# 2 - Etude preliminaire et regression simple

aix=subset(data,STATION=="Aix")
summary(aix)
sd(aix$O3o)
sd(aix$O3p)
par(mfrow=c(1,2))
hist(aix$O3o,breaks=seq(0,300,30),ylim=c(0,100))
hist(aix$O3p,breaks=seq(0,300,30),ylim=c(0,100))
# on impose ici les memes classes pour comparer les histogrammes

x11()
boxplot(aix$O3o,aix$O3p,names=c("[O3]obs","[O3]prevu"))
# Les previsions semblent surestimer globalement les mesures

var.test(aix$O3o,aix$O3p)
# -> les variances peuvent etre considerees comme egales
t.test(aix$O3o,aix$O3p,var.equal=T)
# -> les moyennes sont significativement differentes : les previsions sont biaisees (biais positif)

cor(aix$O3o,aix$O3p)
cor.test(aix$O3o,aix$O3p)
#liaison linéaire significative detectee

plot(aix$O3p,aix$O3o)
regsimple=lm(O3o~O3p,data=aix)
summary(regsimple)
# -> les 2 parametres du modele sont jugés significativement differents de 0
# -> la regression simple n'explique que 22% de la variance totale du predictand
# en considerant d'autres predicteurs, le modele statistique peut certainement etre ameliore

x11()
plot(aix$O3p,aix$O3o,xlab="O3 PREVU MOCAGE",ylab="O3 OBSERVE",
     main="PREVISIONS 24H",pch='+')
abline(regsimple,col="red")

x11()
plot(aix$O3o,type ="l",lwd=2,main="Concentration d'ozone à Aix",xlab="Date",ylab="[O3]")
points(aix$O3p,col="blue",pch="+")
points(fitted(regsimple),col="red",pch="+")
legend(0,268,lty=1,col=c("black"),legend=c("observée"),bty="n")
legend(0,256,pch="+",col=c("blue","red"),legend=c("       prevue","       ASsimple"),bty="n") 
# -> le traitement statistique tire les previsions brutes vers la moyenne du predictand mais est incapable d'atteindre les valeurs extremes
# la variabilité du predictand est mal reproduite, il faut enrichir la regression pour atteindre une variabilite du modele plus forte


# 3 - Regression multiple : predicteurs continus


x11()
par(mfrow=c(3,2))
hist(data$O3p)
hist(data$TEMPE)
hist(data$FF)
hist(data$RMH2O)
hist(data$NO2)
hist(log(data$NO2))
# -> la distribution de NO2 est tres dissymetrique, l'emploi de la fonction log permet d'obtenir un profil plus adapte au modele gaussien.
# La symétrie des distributions des prédicteurs n'est pas une hypothèse du MLG mais elle permet de limiter les occurrences et impacts de valeurs extremes 
# qui seraient très influentes lors de l'estimation des paramètres de régression. Le predicteur elabore sera de plus mieux correle avec le predictand O3o.
# -> on utilisera donc plutot la variable log(NO2)comme prédicteur par la suite :
cor(data$O3o,data$NO2)
cor(data$O3o,log(data$NO2))

x11()
pairs(data[,c(-1,-7)])
# -> on cherche à reperer sur cette matrice graphique d'une part les pb de multicolinearite entre predicteurs et d'autre part les fortes correlations entre 
# les differents predicteurs et le predictand O3o
# -> pas de pb de colinearite trop marquees entre predicteurs ici, les variables les mieux correlees avec O3o semblent etre O3p et TEMPE qui constitueront 
# les meilleurs predicteurs

regmult=lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF,data)
summary(regmult)
# -> l'analyse des tests de Student montre que l'influence de NO2 n'est pas significative
# le % de variance expliquee passe à 51%
model.matrix(regmult)[1:10,]



