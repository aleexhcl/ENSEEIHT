# BE statistiques

# Huc-Lhuillery Alexia

data=read.table("DataTP4.txt", header=TRUE)
data$color <- as.factor(data$color)
summary(data)

lm.out1 <- lm(quality~alcohol,data)
summary(lm.out1)

x11()
plot(data$alcohol,data$quality,xlab="alcohol",ylab="quality",pch='+')
abline(lm.out1, col="red")

# sur ce modèle on observe que la regression linéaire passe au centre des
# valeurs moyennes mais que beaucoup de valeurs sont très éloignées de la droite 
# notamment celles dont la qualité est en dessous de 5, la relation
# ne parait donc pas linéaire, le modèle n'est pas adapté à ces données 

dataR <- subset(data, color=="R")
dataW <- subset(data, color=="W")

t.test(dataR$quality,dataW$quality,var.equal=T)

# les moyennes sont significativement différentes pour ces deux jeux de données 
# avec les valeurs de 5.83 pour la qualité du vin rouge et 
# 5.39 pour la qualité du vin blanc 

x11()
par(mfrow=c(1,2))
hist(dataR$quality)
hist(dataW$quality)

# l'histogramme pour la qualité sur le vin blanc nous montre qu'il y a 
# une dissymétrie dans les valeurs, et pour celui du vin rouge 
# on peut observer qu'on trouve en effet des valeurs de qualité plus élevées

lm.out2=lm(quality~facid+vacid+cacid+sugar+chlorides+fsulf+tsulf+density+pH+sulphates+alcohol+color, data)
summary(lm.out2)

# Pour la variable sugar on obtient une p-value de 0.37 > 0.05, donc on ne rejette pas
# l'hypothèse de nullité du paramètre associé au prédicteur sugar au niveau 0.05, on peut donc considérer
# le prédicteur comme non significatif pour expliquer le prédictant quality (donc prendre 
# pour le paramètre associé à sugar la valeur 0)

# Pour le facteur color, le modèle prend ici comme valeur de référence la valeur R, l'expression
# de la donnée associée à color correspond donc à l'influence de la couleur blanc sur le prédictant 
# par rapport à la couleur rouge. La p-value est de 8e-14 << 0.05, donc la différence de la couleur 
# blanc par rapport au rouge a de l'importance pour le modèle, le paramètre de ce prédicteur doit rester 
# non nul, et on lui donne ici la valeur de -2.5e-1. Au vu de cette valeur négative, on peut dire que la couleur 
# blanche fait diminuer la qualité par rapport à la couleur rouge. 

x11()
plot(fitted(lm.out2),residuals(lm.out2),main="hypothèse homoscedasticite",xlab="Valeurs ajustees (Y*)",ylab="Residus")
# pour l'hypothèse d'homoscédasticité on observe ici que les valeurs ne sont pas vraiment regroupées autours de mêmes
# droites, et qu'elles se dispersent. Il faudrait appliquer une modification sur certains prédictants afin que 
# les variances des erreurs soient très proches.
# L'hypothèse d'homoscédasticité n'est donc pas entièrement satisfaite. 

x11()
qqnorm(residuals(lm.out2))
# On observe un graphique linéaire, et des valeurs qui sont en majorité contenues entre les quantiles -2 et 2.
# Les distributions sont donc très proches de normales, on peut donc confirmer l'hypothèse de normalité.

x11()
acf(residuals(lm.out2))
# On cherche à connaitre la corrélation entre les variables, on observe ici que peut de valeur dépassent de 
# la ligne des 0.05, on peut donc conclure que les variables sont bien indépendantes les unes des autres, ce qui 
# valide l'hypothèse d'indépendance. 

x11() 
plot(fitted(lm.out2),data$quality,xlab="valeur prévues",ylab="valeur observées",pch="+",main="Hypothese de linearite")
# Pour tester l'hypothèse de linéarité, on peut observer que les valeurs évoluent autour d'un même axes mais elles 
# sont dispersée au centre, on a donc peu de linéarité. 

# On peut conserver les prédicteurs dont la p-value est inférieur au niveau alpha = 0.05
# qui sont : vacid, chlorides, fsulf, tsulf, sulphates, alcohol et color 
# Pour pH, la p-value est de 0.05, il est donc a la limite du rejet de l'hypothèse de nullité testée 

library(MASS)

lm.outAIC=stepAIC(lm.out2)
summary(lm.outAIC)
# Ce modèle propose de garder les sept prédicteurs précédents dont la p-value était inférieure
# à 0.05, ainsi que pH 

lm.outint=lm(quality~.*.,data)
summary(lm.outint)

lm.outAICint=stepAIC(lm.outint)
summary(lm.outAICint)
# la dimension du modèle est de 46 

lm.outBICint=stepAIC(lm.outint,k=log(nrow(data)))
summary(lm.outBICint)
# la dimension du modèle est de 23 

# les dimensions des modèles sont grandes, ce qui peut mener à du sur-apprentissage des données 

# lm.outINT=lm( )

x11()
plot(data$quality[1:200], xlab="Indice",ylab="qualité")
points(fitted(lm.outAICint),col="red",pch="+",cex=1.2)
# Le modèle lm.outAICint prévoit bien des valeurs de quality dans la moyenne des valeurs observées, 
# mais les valeurs de quality étant entière on n'obtient seulement une approximation par le modèle lm.outAICint.
# De plus, le modèle permet d'obtenir des valeurs plus extrêmes de quality que nous n'avions pas avec le 
# modèle linéaire lm.out. 

# fonction calculant le BIAIS et le RMSE
scores=function(obs,prev) {
rmse=sqrt(mean((prev-obs)**2))
biais=mean(prev-obs)
print("Biais  RMSE") 
return(round(c(biais,rmse),3))
}

# création de data de test et d'apprentissage
nappr=ceiling(0.8*nrow(data))
ii=sample(1:nrow(data),nappr)
jj=setdiff(1:nrow(data),ii)
datatest=data[jj,]
datapp=data[ii,]

# transformation des modèles sur les données d'apprentissage
lm.outAIC=lm(formula(lm.outAIC),datapp)
lm.outAICint=lm(formula(lm.outAICint),datapp)
lm.outBICint=lm(formula(lm.outBICint),datapp)
lm.outINT=lm(formula(lm.outint),datapp) # de dimensions plus que 10 

scores(datapp$quality,fitted(lm.outAIC))
# "Biais  RMSE"
#  0.000 0.636
scores(datatest$quality,predict(lm.outAIC,datatest))
# "Biais  RMSE"
# -0.029  0.630
scores(datapp$quality,fitted(lm.outAICint))
# "Biais  RMSE"
#  0.000 0.588
scores(datatest$quality,predict(lm.outAICint,datatest))
# "Biais  RMSE"
# -0.022  0.634
scores(datapp$quality,fitted(lm.outBICint))
# "Biais  RMSE"
#  0.000 0.605
scores(datatest$quality,predict(lm.outBICint,datatest))
# "Biais  RMSE"
# -0.016  0.639
scores(datapp$quality,fitted(lm.outINT))
# "Biais  RMSE"
#  0.000 0.582
scores(datatest$quality,predict(lm.outINT,datatest))
# "Biais  RMSE"
# -0.020  0.652

# On observe que pour tous les scores sur les fichiers d'apprentissage les modèles sont non biaisées,
# mais ils le sont pour les données de test, le moins biaisé est le modèle BICint.
# Pour le RMSE, il est moins élevé pour les données de test que pour les données d'apprentissage 
# seulement pour AIC, et il est similaire entre tous les modèles sur les données de test.

RMSE=function(obs,pr){
return(sqrt(mean((pr-obs)^2)))}

k=100 # nb iterations

tab=matrix(nrow=k,ncol=8)

for (i in 1:k) {

nappr=ceiling(0.8*nrow(data))
ii=sample(1:nrow(data),nappr)
jj=setdiff(1:nrow(data),ii)
datatest=data[jj,]
datapp=data[ii,]

# Estimation des modeles
lm.outAIC=lm(formula(lm.outAIC),datapp)
lm.outAICint=lm(formula(lm.outAICint),datapp)
lm.outBICint=lm(formula(lm.outBICint),datapp)
lm.outINT=lm(formula(lm.outint),datapp)

# Scores sur apprentissage
tab[i,1]=RMSE(datapp$quality,predict(lm.outAIC))
tab[i,2]=RMSE(datapp$quality,predict(lm.outAICint))
tab[i,3]=RMSE(datapp$quality,predict(lm.outBICint))
tab[i,4]=RMSE(datapp$quality,predict(lm.outINT))

# Scores sur test
tab[i,5]=RMSE(datatest$quality,predict(lm.outAIC,datatest))
tab[i,6]=RMSE(datatest$quality,predict(lm.outAICint,datatest))
tab[i,7]=RMSE(datatest$quality,predict(lm.outBICint,datatest))
tab[i,8]=RMSE(datatest$quality,predict(lm.outINT,datatest))

}

x11()
boxplot(tab,col=c(rep("blue",4),rep("red",4)),xlab="bleu=apprentissage - rouge=test",
names=c("lm.outAIC","lm.outAICint","lm.outBICint","lm.outINT","lm.outAIC","lm.outAICint","lm.outBICint","lm.outINT"),main=("Modele lineaire gaussien - Score RMSE"))

# Le modèle BICint possède une disperssion autour de la médianes qui est moins importante que pour
# les autres modèles sauf AICint, il est aussi un des deux modèles les plus bas, et la dispersions en dehors
# des premiers quartiles est moins élevée avec AICint. On observe pourtant que pour AICint les résultats sur des 
# données de tests sont plus éloignés des données d'apprentissage que BICint. Ce serait donc le modèle BICint
# le plus adapté à utiliser pour ces données. 

# Les perfomances du modèle dépendent en effet de la couleur du vin car nous avons ici considéré la couleur comme
# l'un des prédicteurs de la qualité, sans ce prédicteurs les paramètres du modèles ne seront pas exactement
# les mêmes. 

